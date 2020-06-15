provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "../../"

	# Use an existing IAM role
	use_existing_iam_role = true
	iam_role_name         = "lacework-ct-iam-8805c0bf"
	iam_role_external_id  = "TG=UvBUeNXbkpkJy"

	# Use an existing CloudTrail
	enable_cloudtrail    = false
	bucket_name          = "lacework-ct-bucket-8805c0bf"
	sns_topic_name       = "lacework-ct-sns-8805c0bf"
}
