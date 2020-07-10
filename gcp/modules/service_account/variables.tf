variable "required_apis" {
	type = map
	default = {
	  iam               = "iam.googleapis.com"
	  kms               = "cloudkms.googleapis.com"
	  dns               = "dns.googleapis.com"
	  compute           = "compute.googleapis.com"
	  logging           = "logging.googleapis.com"
	  containers        = "container.googleapis.com"
	  monitoring        = "monitoring.googleapis.com"
	  service_usage     = "serviceusage.googleapis.com"
	  resource_manager  = "cloudresourcemanager.googleapis.com"
	  storage_component = "storage-component.googleapis.com"
	}
}

variable "org_integration" {
	type        = bool
	default     = false
	description = "If set to true, configure an organization level integration"
}

variable "existing_service_account" {
	type        = string
	default     = ""
	description = "An existing Service Account ID to use"
}

variable "service_account_name" {
	type        = string
	default     = "lacework-svc-account"
	description = "The Service Account name"
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

variable "create" {
	type        = bool
	default     = true
	description = "Set to false to prevent the module from creating any resources"
}
