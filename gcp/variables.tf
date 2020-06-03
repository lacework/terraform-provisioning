variable "lacework_account" {
  type = string
}

variable "lacework_api_key" {
  type = string
}

variable "lacework_api_secret" {
  type = string
}

variable "lacework_integration_config_name" {
  type = string
  default = "GCP config"
}

variable "lacework_integration_auditlog_name" {
  type = string
  default = "GCP auditlog"
}

variable "prefix" {
  type = string
  description = "The Prefix used for all resources in this example"
}

variable "credentials_file" {
  type = string
  description = "Location of the credentials file for gcp"
}

variable "org_integration" {
  type = bool
  description = "If set to true, configure an organization level integration"
  default = false
}

variable "project_id" {
  type = string
  description = "Id of the project"
}

variable "organization_id" {
  type = string
  description = "Id of the organization"
}

variable "region" {
  type = string
  description = "Region you want to create resources in"
  default = "us-central1"
}

variable "zone" {
  type = string
  description = "Zone you want to create resources in"
  default = "us-central1-c"
}

variable "audit_log" {
  type = bool
  description = "If set to true, create resources for both Config and Audit Logs"
}

variable "existing_bucket_name" {
  type = string
  description = "Name of an existing bucket you want to send the logs to"
  default = ""
}

variable "force_destroy_bucket" {
  type = bool
  default = false
}

variable "required_apis" {
  type = map
  default = {
    iam = "iam.googleapis.com"
    resource_manager = "cloudresourcemanager.googleapis.com"
    kms = "cloudkms.googleapis.com"
    compute = "compute.googleapis.com"
    dns = "dns.googleapis.com"
    monitoring = "monitoring.googleapis.com"
    logging = "logging.googleapis.com"
    storage_component = "storage-component.googleapis.com"
    service_usage = "serviceusage.googleapis.com"
    containers = "container.googleapis.com"
  }
}
