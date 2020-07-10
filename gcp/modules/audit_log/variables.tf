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
	type    = string
	default = ""
}

variable "existing_bucket_name" {
	type        = string
	default     = ""
	description = "The name of an existing bucket you want to send the logs to"
}

variable "bucket_force_destroy" {
	type    = bool
	default = false
}

variable "prefix" {
	type        = string
	default     = "lacework-audit"
	description = "The prefix that will be use at the beginning of every generated resource"
}

variable "lacework_integration_name" {
	type    = string
	default = "TF audit_log"
}
