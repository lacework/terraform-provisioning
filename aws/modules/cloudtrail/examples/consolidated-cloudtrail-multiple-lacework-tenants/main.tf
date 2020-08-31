provider "lacework" {
	alias = "main"
}

provider "aws" {
	alias = "main"
}

variable "aws_accounts" {
  type    = list(string)
  default = [
		"123456789011",
		// ... list all accounts
		"123456789019",
	]
}

resource "aws_sqs_queue" "lw_ct_sqs_sub_accounts" {
	provider = aws.main
	count    = length(var.aws_accounts)
	name     = "lw-ct-sqs-${var.aws_accounts[count.index]}"
}

module "main_cloudtrail" {
	source    = "github.com/lacework/terraform-provisioning/aws/modules/cloudtrail"
	providers = {
		aws      = aws.main
		lacework = lacework.main
	}
	consolidated_trail = true
	sqs_queues         = aws_sqs_queue.lw_ct_sqs_sub_accounts.*.arn
}

resource "lacework_integration_aws_ct" "main" {
	provider  = lacework.main
	name      = "TF consolidated"
	queue_url = aws_sqs_queue.lw_ct_sqs_sub_accounts.0.id
	credentials {
		role_arn    = module.main_cloudtrail.iam_role_arn
		external_id = module.main_cloudtrail.external_id
	}
}
