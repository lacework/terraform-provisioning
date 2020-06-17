provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "../../"

	# Use an existing CloudTrail
	enable_cloudtrail    = false
	bucket_name          = "lacework-ct-bucket-8805c0bf"
	sns_topic_name       = "lacework-ct-sns-8805c0bf"
}

