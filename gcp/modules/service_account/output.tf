output "created" {
	value       = var.create
	description = "Was the Service Account created"
}

output "name" {
	value       = local.service_account_name
	description = "The Service Account name"
}

output "email" {
	value       = local.service_account_email
	description = "The Service Account email"
}

output "project_id" {
	value       = local.project_id
	description = "The Project ID"
}

output "private_key" {
  value       = google_service_account_key.lacework.private_key
	description = "The External ID configured into the IAM role"
}
