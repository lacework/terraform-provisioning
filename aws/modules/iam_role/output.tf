output "created" {
	value       = var.create
	description = "Was the IAM Role created"
}

output "name" {
	value       = var.iam_role_name
	description = "IAM Role name"
}

output "arn" {
	value       = data.aws_iam_role.selected.arn
	description = "IAM Role ARN"
}

output "external_id" {
	value       = var.create ? random_string.external_id.result : ""
	description = "The External ID configured into the IAM role"
}
