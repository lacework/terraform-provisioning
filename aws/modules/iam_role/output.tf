output "created" {
	value       = var.create
	description = "Was the IAM Role created"
}

output "name" {
	value       = var.iam_role_name
	description = "IAM Role name"
}

output "arn" {
	value       = var.create ? aws_iam_role.lacework_iam_role[0].arn : ""
	description = "IAM Role ARN"
}

output "external_id" {
	value       = var.create ? random_string.external_id[0].result : ""
	description = "The External ID configured into the IAM role"
}
