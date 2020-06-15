output "external_id" {
	value = module.lacework_iam_role.external_id
}

output "iam_role_name" {
	value = module.lacework_iam_role.name
}

output "iam_role_arn" {
	value = module.lacework_iam_role.arn
}
