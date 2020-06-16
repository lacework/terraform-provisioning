provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "../../"

	# Use an existing IAM role
	use_existing_iam_role = true
	iam_role_name         = "lacework_iam_role"
	iam_role_external_id  = "1GrDkEZV5VJ@=nLm"

	# Use an existing CloudTrail
	enable_cloudtrail    = false
	bucket_name          = "lacework-ct-bucket-7bb591f4"
	sns_topic_name       = "lacework-ct-sns-7bb591f4"
}
