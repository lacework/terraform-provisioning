module "lacework_cfg_iam_role" {
	source                  = "../iam_role"
	iam_role_name           = var.iam_role_name
	lacework_aws_account_id = var.lacework_aws_account_id
	external_id_length      = var.external_id_length
}

resource "aws_iam_role_policy_attachment" "security_audit_policy_attachment" {
	role       = module.lacework_cfg_iam_role.name
	policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
	depends_on = [module.lacework_cfg_iam_role]
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_time" {
	create_duration = var.wait_time
	depends_on      = [aws_iam_role_policy_attachment.security_audit_policy_attachment]
}

resource "lacework_integration_aws_cfg" "default" {
	name = var.lacework_integration_name
	credentials {
		role_arn    = module.lacework_cfg_iam_role.arn
		external_id = module.lacework_cfg_iam_role.external_id
	}
	depends_on = [time_sleep.wait_time]
}
