variable "iam_role_name" {
	type        = string
	default     = "lacework_iam_role"
	description = "The IAM role name"
}

variable "lacework_aws_account_id" {
	type        = string
	default     = "434813966438"
	description = "The Lacework AWS account that the IAM role will grant access"
}

variable "external_id_length" {
	type        = number
	default     = 16
	description = "The length of the external ID to generate"
}

variable "create" {
	type        = bool
	default     = true
	description = "Set to false to prevent the module from creating any resources"
}

variable "wait_time" {
	type = string
	default = "5s"
	description = "Amount of time to wait before the next resource is provisioned."
}
