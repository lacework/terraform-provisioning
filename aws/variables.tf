////////////////////////////////
// AWS Connection

variable "aws_profile" {
  type = string
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

variable "sns_topic_name" {
  default = "lacework-sns-topic"
}

variable "sqs_queue_name" {
  default = "lacework-sqs-queue"
}

variable "cloudtrail_name" {
  default = "lacework-cloudtrail"
}



////////////////////////////////
// Tags

variable "tag_customer" {}

variable "tag_project" {}

variable "tag_name" {}

variable "tag_dept" {}

variable "tag_contact" {}

variable "tag_application" {}

variable "tag_ttl" {
  default = 4
}

variable "aws_key_pair_file" {}

variable "aws_key_pair_name" {}
