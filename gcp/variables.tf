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
