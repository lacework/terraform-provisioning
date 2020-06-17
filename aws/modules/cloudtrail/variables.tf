variable "use_existing_iam_role" {
	type        = bool
	default     = false
	description = "Set this to true to use an existing IAM role"
}

variable "iam_role_name" {
	type    = string
	default = ""
}

variable "iam_role_external_id" {
	type    = string
	default = ""
}

variable "external_id_length" {
	type        = number
	default     = 16
	description = "The length of the external ID to generate"
}

variable "prefix" {
	type        = string
	default     = "lacework-ct"
	description = "The prefix that will be use at the beginning of every generated resource"
}

variable "bucket_name" {
	type    = string
	default = ""
}

variable "bucket_force_destroy" {
	type    = bool
	default = false
}

variable "sns_topic_name" {
	type    = string
	default = ""
}

variable "sqs_queue_name" {
	type    = string
	default = ""
}

variable "use_existing_cloudtrail" {
	type        = bool
	default     = false
	description = "Set this to true to use an existing cloudtrail. Default behavior enables new cloudtrail"
}

variable "cloudtrail_name" {
	type    = string
	default = "lacework-cloudtrail"
}

variable "cross_account_policy_name" {
	type    = string
	default = ""
}

variable "lacework_integration_name" {
	type    = string
	default = "TF cloudtrail"
}

variable "lacework_aws_account_id" {
	type        = string
	default     = "434813966438"
	description = "The Lacework AWS account that the IAM role will grant access"
}
