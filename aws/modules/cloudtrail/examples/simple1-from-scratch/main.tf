provider "lacework" { }

provider "aws" { }

module "aws_cloudtrial" {
	source = "../../"
}
