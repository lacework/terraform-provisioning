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

variable "lacework_integration_name" {
	type    = string
	default = "TF config"
}

variable "external_id_length" {
	type        = number
	default     = 16
	description = "The length of the external ID to generate. Max length is 1224"
}
