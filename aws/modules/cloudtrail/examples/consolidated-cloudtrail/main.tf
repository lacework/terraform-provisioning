provider "lacework" {
	alias = "main"
}

provider "aws" {
	alias = "main"
}

module "main_cloudtrail" {
	source    = "github.com/lacework/terraform-provisioning/aws/modules/cloudtrail"
	providers = {
		aws      = aws.main
		lacework = lacework.main
	}
	consolidated_trail = true
}

provider "aws" {
	alias = "sub_account"
}

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
	provider              = aws.sub_account
	name                  = "lacework-sub-trail"
	is_multi_region_trail = true
	s3_bucket_name        = module.main_cloudtrail.bucket_name
	sns_topic_name        = module.main_cloudtrail.sns_arn
}
