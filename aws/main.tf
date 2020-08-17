provider "aws" {}

provider "lacework" {}

module "aws_config" {
	source = "github.com/lacework/terraform-provisioning/aws/modules/config"
}

module "aws_cloudtrail" {
	source                = "github.com/lacework/terraform-provisioning/aws/modules/cloudtrail"
	bucket_force_destroy  = true
	use_existing_iam_role = true
	iam_role_name         = module.aws_config.iam_role_name
	iam_role_external_id  = module.aws_config.external_id
}
