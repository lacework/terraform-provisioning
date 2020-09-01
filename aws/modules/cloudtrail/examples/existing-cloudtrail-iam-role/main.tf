provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "../../"

	# Use an existing CloudTrail
	use_existing_cloudtrail    = true
	bucket_arn                 = "arn:aws:s3:::lacework-ct-bucket-8805c0bf"
	bucket_name                = "lacework-ct-bucket-7bb591f4"
	sns_topic_name             = "lacework-ct-sns-7bb591f4"

	# Use an existing IAM role
	use_existing_iam_role = true
	iam_role_arn          = "arn:aws:iam::123456789012:role/lw-existing-role"
	iam_role_name         = "lw-existing-role"
	iam_role_external_id  = "1GrDkEZV5VJ@=nLm"
}
