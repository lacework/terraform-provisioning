////////////////////////////////
// Lacework
//
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
  default = "AWS config"
}

variable "lacework_integration_cloudtrail_name" {
  type = string
  default = "AWS cloundtrail"
}

////////////////////////////////
// AWS Connection

variable "aws_profile" {
  type = string
  default = "default"
}

variable "aws_region" {}

variable "credentials_file" {
  default = "~/.aws/credentials"
}

////////////////////////////////
// ENV

variable "bucket_name" {
  default = "lacework-cloudtrail-bucket"
}

variable "external_id" {
  default = "12345"
}

variable "iam_role_name" {
  default = "lacework_iam_role"
}

variable "sns_topic_name" {
  default = "lacework-sns-topic"
}

variable "sqs_queue_name" {
  default = "lacework-sqs-queue"
}

variable "cloudtrail_name" {
  default = "lacework-cloudtrail"
}

variable "force_destroy_bucket" {
  default = false
}

variable "lacework_aws_account_id" {
  default = "434813966438"
}
