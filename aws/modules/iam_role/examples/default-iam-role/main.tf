provider "aws" { }

module "lacework_iam_role" {
	source = "../../"
}
