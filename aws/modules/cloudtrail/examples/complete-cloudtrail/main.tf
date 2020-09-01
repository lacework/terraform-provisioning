provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "../../"
}
