provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "github.com/lacework/terraform-provisioning/aws/modules/cloudtrail"

	# Use an existing CloudTrail
	use_existing_cloudtrail    = true
	bucket_arn                 = "arn:aws:s3:::lacework-ct-bucket-8805c0bf"
	bucket_name                = "lacework-ct-bucket-8805c0bf"
	sns_topic_name             = "lacework-ct-sns-8805c0bf"
}

