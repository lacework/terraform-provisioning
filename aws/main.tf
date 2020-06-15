provider "aws" {}

provider "lacework" {}

module "aws_config" {
	source = "./modules/config"
}

module "aws_cloudtrail" {
	source = "./modules/cloudtrail"

	use_existing_iam_role = true
	bucket_force_destroy  = true
	iam_role_name         = module.aws_config.iam_role_name
	iam_role_external_id  = module.aws_config.external_id
}
