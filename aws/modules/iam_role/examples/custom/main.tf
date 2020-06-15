provider "aws" { }

module "lacework_iam_role" {
	source             = "../../"
	iam_role_name      = "custom-role-name"
	external_id_length = 256
}
