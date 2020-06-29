output "external_id" {
	value       = module.lacework_cfg_iam_role.external_id
	description = "The External ID configured into the IAM role"
}

output "iam_role_name" {
	value       = module.lacework_cfg_iam_role.name
	description = "IAM Role name"
}

output "iam_role_arn" {
	value       = module.lacework_cfg_iam_role.arn
	description = "IAM Role ARN"
}
