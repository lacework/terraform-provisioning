provider "lacework" {
	alias = "sub_tenant"
}

provider "aws" {
	alias = "sub_account"
}

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
	provider              = aws.sub_account
	name                  = "lacework-sub-trail"
	is_multi_region_trail = true
	s3_bucket_name        = module.main_cloudtrail.bucket_name
	sns_topic_name        = module.main_cloudtrail.sns_arn
}

resource "lacework_integration_aws_ct" "sub_account" {
	provider  = lacework.sub_tenant
	name      = "TF consolidated"
	queue_url = aws_sqs_queue.lw_ct_sqs_sub_accounts.1.id
	credentials {
		role_arn    = module.main_cloudtrail.iam_role_arn
		external_id = module.main_cloudtrail.external_id
	}
	depends_on = [aws_cloudtrail.lw_sub_account_cloudtrail]
}
