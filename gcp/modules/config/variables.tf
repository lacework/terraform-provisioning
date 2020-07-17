variable "org_integration" {
	type        = bool
	default     = false
	description = "If set to true, configure an organization level integration"
}

variable "organization_id" {
	type        = string
	default     = ""
	description = "The organization ID, required if org_integration is set to true"
}

variable "project_id" {
	type        = string
	default     = ""
	description = "A project ID different from the default defined inside the provider"
}

variable "use_existing_service_account" {
	type        = bool
	default     = false
	description = "Set this to true to use an existing Service Account"
}

variable "service_account_name" {
	type        = string
	default     = ""
	description = "The Service Account name (required when use_existing_service_account is set to true)"
}

variable "service_account_private_key" {
	type        = string
	default     = ""
	description = "The private key in JSON format, base64 encoded (required when use_existing_service_account is set to true)"
}

variable "lacework_integration_name" {
	type    = string
	default = "TF config"
}
