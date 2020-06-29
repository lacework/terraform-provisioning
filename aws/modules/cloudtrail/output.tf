output "bucket_name" {
	value       = local.bucket_name
	description = "S3 Bucket name"
}

output "sqs_name" {
	value       = local.sqs_queue_name
	description = "SQS Queue name"
}

output "sns_arn" {
	value       = aws_sns_topic.lacework_cloudtrail_sns_topic.arn
	description = "SNS Topic ARN"
}

output "external_id" {
	value       = local.external_id
	description = "The External ID configured into the IAM role"
}

output "iam_role_name" {
	value       = local.iam_role_name
	description = "IAM Role name"
}

output "iam_role_arn" {
	value       = module.lacework_ct_iam_role.arn
	description = "IAM Role ARN"
}
