output "cloud_trail_id" {
  value = aws_cloudtrail.lacework_cloudtrail.id
}

output "s3_bucket_id" {
  value = aws_s3_bucket.lacework_cloudtrail_bucket.id
}

output "sns_topic_id" {
  value = aws_sns_topic.lacework_cloudtrail_sns_topic.id
}

output "sqs_sqs_id" {
  value = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
}

output "sqs_sqs_arn" {
  value = aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn
}

output "iam_role_id" {
  value = aws_iam_role.lacework_iam_role.id
}
