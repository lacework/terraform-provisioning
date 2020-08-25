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
	description = "The length of the external ID to generate. Max length is 1224"
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

variable "wait_time" {
	type = string
	default = "10s"
	description = "Amount of time to wait before the next resource is provisioned."
}
