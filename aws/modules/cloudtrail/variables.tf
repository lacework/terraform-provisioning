variable "consolidated_trail" {
	type        = bool
	default     = false
	description = "Set this to true to configure a consolidated cloudtrail"
}

variable "use_existing_iam_role" {
	type        = bool
	default     = false
	description = "Set this to true to use an existing IAM role"
}

variable "iam_role_name" {
	type        = string
	default     = ""
	description = "The IAM role name. Required to match with iam_role_arn if use_existing_iam_role is set to true"
}

variable "iam_role_arn" {
	type        = string
	default     = ""
	description = "The IAM role ARN is required when setting use_existing_iam_role to true"
}

variable "iam_role_external_id" {
	type        = string
	default     = ""
	description = "The external ID configured inside the IAM role is required when setting use_existing_iam_role to true"
}

variable "external_id_length" {
	type        = number
	default     = 16
	description = "The length of the external ID to generate. Max length is 1224. Ignored when use_existing_iam_role is set to true"
}

variable "prefix" {
	type        = string
	default     = "lacework-ct"
	description = "The prefix that will be use at the beginning of every generated resource"
}

variable "bucket_name" {
	type    = string
	default = ""
	description = "The S3 bucket name is required when setting use_existing_cloudtrail to true"
}

variable "bucket_arn" {
	type    = string
	default = ""
	description = "The S3 bucket ARN is required when setting use_existing_cloudtrail to true"
}

variable "bucket_enable_encryption" {
	type    = bool
	default = false
}

variable "bucket_enable_logs" {
	type    = bool
	default = false
}

variable "bucket_enable_versioning" {
	type    = bool
	default = false
}

variable "bucket_force_destroy" {
	type    = bool
	default = false
}

variable "bucket_sse_algorithm" {
	type        = string
	default     = "AES256"
	description = "The encryption algorithm to use for S3 bucket server-side encryption"
}

variable "bucket_sse_key_arn" {
	type        = string
	default     = ""
	description = "The ARN of the KMS encryption key to be used (Required when using 'aws:kms')"
}

variable "log_bucket_name" {
	type    = string
	default = ""
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

variable "use_existing_s3_bucket" {
	type        = bool
	default     = false
}

variable "cloudtrail_name" {
	type    = string
	default = "lacework-cloudtrail"
}

variable "cross_account_policy_name" {
	type    = string
	default = ""
}

variable "sqs_queues" {
	type        = list(string)
	default     = []
	description = "List of SQS queues to configure in the Lacework cross-account policy"
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
