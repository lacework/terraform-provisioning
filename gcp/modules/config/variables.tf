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

variable "lacework_integration_name" {
	type    = string
	default = "TF config"
}
