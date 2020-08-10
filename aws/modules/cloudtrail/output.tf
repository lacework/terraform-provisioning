output "bucket_name" {
	value       = local.bucket_name
	description = "S3 Bucket name"
}

output "sqs_name" {
	value       = local.sqs_queue_name
	description = "SQS Queue name"
}

output "sqs_arn" {
	value       = aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn
	description = "SQS Queue ARN"
}

output "sns_arn" {
	value       = aws_sns_topic.lacework_cloudtrail_sns_topic.arn
	description = "SNS Topic ARN"
}

output "external_id" {
	value       = local.iam_role_external_id
	description = "The External ID configured into the IAM role"
}

output "iam_role_name" {
	value       = var.iam_role_name
	description = "The IAM Role name"
}

output "iam_role_arn" {
	value       = local.iam_role_arn
	description = "The IAM Role ARN"
}
