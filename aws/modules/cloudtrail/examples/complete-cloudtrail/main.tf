provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "github.com/lacework/terraform-provisioning/aws/modules/cloudtrail"
}
