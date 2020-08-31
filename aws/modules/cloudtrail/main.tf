locals {
	bucket_name     = length(var.bucket_name) > 0 ?     var.bucket_name :     "${var.prefix}-bucket-${random_id.uniq.hex}"
	bucket_arn      = var.use_existing_cloudtrail ?     var.bucket_arn  :     aws_s3_bucket.cloudtrail_bucket[0].arn
	log_bucket_name = length(var.log_bucket_name) > 0 ? var.log_bucket_name : "${local.bucket_name}-access-logs"
	sns_topic_name  = length(var.sns_topic_name) > 0 ?  var.sns_topic_name :  "${var.prefix}-sns-${random_id.uniq.hex}"
	sqs_queue_name  = length(var.sqs_queue_name) > 0 ?  var.sqs_queue_name :  "${var.prefix}-sqs-${random_id.uniq.hex}"
	cross_account_policy_name = (
		length(var.cross_account_policy_name) > 0 ? var.cross_account_policy_name : "${var.prefix}-cross-acct-policy-${random_id.uniq.hex}"
	)
	iam_role_arn         = module.lacework_ct_iam_role.created ? module.lacework_ct_iam_role.arn :         var.iam_role_arn
	iam_role_external_id = module.lacework_ct_iam_role.created ? module.lacework_ct_iam_role.external_id : var.iam_role_external_id
	iam_role_name        = var.use_existing_iam_role ? var.iam_role_name : (
		length(var.iam_role_name) > 0 ? var.iam_role_name : "${var.prefix}-iam-${random_id.uniq.hex}"
	)
}

resource "random_id" "uniq" {
	byte_length = 4
}

resource "aws_cloudtrail" "lacework_cloudtrail" {
	count                 = var.use_existing_cloudtrail ? 0 : 1
	name                  = var.cloudtrail_name
	is_multi_region_trail = true
	s3_bucket_name        = local.bucket_name
	kms_key_id            = var.bucket_sse_key_arn
	sns_topic_name        = aws_sns_topic.lacework_cloudtrail_sns_topic.arn
	depends_on            = [aws_s3_bucket.cloudtrail_bucket]
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
	count         = var.use_existing_cloudtrail ? 0 : 1
	bucket        = local.bucket_name
	force_destroy = var.bucket_force_destroy
	policy        = data.aws_iam_policy_document.cloudtrail_s3_policy.json

	versioning {
		enabled = var.bucket_enable_versioning
	}

	dynamic "logging" {
		for_each = var.bucket_enable_logs == true ? [1] : []
		content {
			target_bucket = aws_s3_bucket.cloudtrail_log_bucket[0].id
			target_prefix = "log/"
		}
	}

	dynamic "server_side_encryption_configuration" {
		for_each = var.bucket_enable_encryption == true ? [1] : []
		content {
			rule {
				apply_server_side_encryption_by_default {
					kms_master_key_id = var.bucket_sse_key_arn
					sse_algorithm = var.bucket_sse_algorithm
				}
			}
		}
	}
}

resource "aws_s3_bucket" "cloudtrail_log_bucket" {
	count         = var.use_existing_cloudtrail ? 0 : (var.bucket_enable_logs ? 1 : 0)
	bucket        = local.log_bucket_name
	force_destroy = var.bucket_force_destroy
	acl           = "log-delivery-write"

	versioning {
		enabled = var.bucket_enable_versioning
	}

	dynamic "server_side_encryption_configuration" {
		for_each = var.bucket_enable_encryption == true ? [1] : []
		content {
			rule {
				apply_server_side_encryption_by_default {
					kms_master_key_id = var.bucket_sse_key_arn
					sse_algorithm = var.bucket_sse_algorithm
				}
			}
		}
	}
}

# we need the identity of the caller to get their account_id for the s3 bucket
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "cloudtrail_s3_policy" {
	version = "2012-10-17"

	statement {
		sid       = "AWSCloudTrailAclCheck20150319"
		actions   = ["s3:GetBucketAcl"]
		resources = ["arn:aws:s3:::${local.bucket_name}"]

		principals {
			type        = "Service"
			identifiers = ["cloudtrail.amazonaws.com"]
		}
	}

	statement {
		sid       = "AWSCloudTrailWrite20150319"
		actions   = ["s3:PutObject"]
		resources = var.consolidated_trail ? (["arn:aws:s3:::${local.bucket_name}/AWSLogs/*"]) : (["arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"])

		principals {
			type        = "Service"
			identifiers = ["cloudtrail.amazonaws.com"]
		}

		condition {
			test     = "StringEquals"
			variable = "s3:x-amz-acl"
			values   = ["bucket-owner-full-control"]
		}
	}

	statement {
		sid     = "ForceSSLOnlyAccess"
		actions = ["s3:*"]
		effect  = "Deny"

		resources = [
			"arn:aws:s3:::${local.bucket_name}",
			"arn:aws:s3:::${local.bucket_name}/*",
		]

		principals {
			type        = "AWS"
			identifiers = ["*"]
		}

		condition {
			test     = "Bool"
			variable = "aws:SecureTransport"
			values   = ["false"]
		}
	}
}

resource "aws_sns_topic" "lacework_cloudtrail_sns_topic" {
	name   = local.sns_topic_name
}

data "aws_iam_policy_document" "sns_topic_policy" {
	version = "2012-10-17"
	statement {
		actions   = ["SNS:Publish"]
		sid       = "AWSCloudTrailSNSPolicy20131101"
		resources = [aws_sns_topic.lacework_cloudtrail_sns_topic.arn]
	
		principals {
			type        = "Service"
			identifiers = ["cloudtrail.amazonaws.com"]
		}
	}
}

resource "aws_sns_topic_policy" "default" { 
	arn    = aws_sns_topic.lacework_cloudtrail_sns_topic.arn
	policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sqs_queue" "lacework_cloudtrail_sqs_queue" {
	name = local.sqs_queue_name
}

resource "aws_sqs_queue_policy" "lacework_sqs_queue_policy" {
	queue_url = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
	policy    = <<POLICY
{
	"Version": "2012-10-17",
	"Id": "lacework_sqs_policy_${random_id.uniq.hex}",
	"Statement": [
		{
			"Sid": "AllowLaceworkSNSTopicToSendMessage",
			"Effect": "Allow",
			"Principal": {
				"AWS": "*"
			},
			"Action": "SQS:SendMessage",
			"Resource": "${aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn}",
			"Condition": {
				"ArnEquals": {
					"aws:SourceArn": "${aws_sns_topic.lacework_cloudtrail_sns_topic.arn}"
				}
			}
		}
	]
}
POLICY
}

resource "aws_sns_topic_subscription" "lacework_sns_topic_sub" {
	topic_arn = aws_sns_topic.lacework_cloudtrail_sns_topic.arn
	protocol  = "sqs"
	endpoint  = aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn
}

data "aws_iam_policy_document" "cross_account_policy" {
	version = "2012-10-17"

	statement { 
		sid       = "ReadLogFiles"
		actions   = ["s3:Get*"]
		resources = ["${local.bucket_arn}/*"]
	}

	dynamic "statement" {
		for_each = var.bucket_enable_encryption == true ? (var.bucket_sse_algorithm == "aws:kms" ? [1] : []) : []
		content {
			sid = "DecryptLogFiles"
			actions = ["kms:Decrypt"]
			resources = [var.bucket_sse_key_arn]
		}
	}

	statement { 
		sid       = "GetAccountAlias"
		actions   = ["iam:ListAccountAliases"]
		resources = ["*"]
	}

	statement { 
		sid       = "ListLogFiles"
		resources = [local.bucket_arn]
		actions   = ["s3:ListBucket"]

		condition {
			test     = "StringLike"
			variable = "s3:prefix"
			values   = ["*AWSLogs/"]
		}
	}

	statement { 
		sid       = "ConsumeNotifications"
		resources = flatten([var.sqs_queues, [aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn]])
		actions   = [
			"sqs:GetQueueAttributes",
			"sqs:GetQueueUrl",
			"sqs:DeleteMessage",
			"sqs:ReceiveMessage"
		]
	}

	statement { 
		sid       = "Debug"
		resources = ["*"]
		actions   = [
			"cloudtrail:DescribeTrails",
			"cloudtrail:GetTrail",
			"cloudtrail:GetTrailStatus",
			"cloudtrail:ListPublicKeys",
			"s3:GetBucketAcl",
			"s3:GetBucketPolicy",
			"s3:ListAllMyBuckets",
			"s3:GetBucketLocation",
			"s3:GetBucketLogging",
			"sns:GetSubscriptionAttributes",
			"sns:GetTopicAttributes",
			"sns:ListSubscriptions",
			"sns:ListSubscriptionsByTopic",
			"sns:ListTopics"
		]
	}
}

resource "aws_iam_policy" "cross_account_policy" {
	name        = local.cross_account_policy_name
	description = "A cross account policy to allow Lacework to pull config and cloudtrail"
	policy      = data.aws_iam_policy_document.cross_account_policy.json
}

module "lacework_ct_iam_role" {
	source                  = "../iam_role"
	create                  = var.use_existing_iam_role ? false : true
	iam_role_name           = local.iam_role_name
	lacework_aws_account_id = var.lacework_aws_account_id
	external_id_length      = var.external_id_length
}

resource "aws_iam_role_policy_attachment" "lacework_cross_account_iam_role_policy" {
	role       = local.iam_role_name
	policy_arn = aws_iam_policy.cross_account_policy.arn 
	depends_on = [module.lacework_ct_iam_role]
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_time" {
	create_duration = var.wait_time
	depends_on      = [
		aws_iam_role_policy_attachment.lacework_cross_account_iam_role_policy,
		aws_sns_topic_subscription.lacework_sns_topic_sub,
		aws_cloudtrail.lacework_cloudtrail
	]
}

resource "lacework_integration_aws_ct" "default" {
	// do not create a CT integration if the user provides multiple
	// SQS queues to configure, it means that they want to fan-out
	// with a lambda function that acks like a gateway
	count     = length(var.sqs_queues) > 0 ? 0 : 1
	name      = var.lacework_integration_name
	queue_url = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
	credentials {
		role_arn    = local.iam_role_arn
		external_id = local.iam_role_external_id
	}
	depends_on = [time_sleep.wait_time]
}
