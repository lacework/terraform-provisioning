locals {
	resource_level        = var.org_integration ? "ORGANIZATION" : "PROJECT"
	resource_id           = var.org_integration ? var.organization_id : module.lacework_cfg_svc_account.project_id
	service_account_name  = var.use_existing_service_account ? (
		var.service_account_name 
	) : (
		length(var.service_account_name) > 0 ? var.service_account_name : "lacework-svc-account"
	)
	service_account_json_key = jsondecode(var.use_existing_service_account ? (
		base64decode(var.service_account_private_key)
	) : (
		base64decode(module.lacework_cfg_svc_account.private_key)
	))
}

module "lacework_cfg_svc_account" {
	source               = "../service_account"
	create               = var.use_existing_service_account ? false : true
	service_account_name = local.service_account_name
	org_integration      = var.org_integration
	organization_id      = var.organization_id
	project_id           = var.project_id
}

# wait for 5 seconds for things to settle down in the GCP side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_5_seconds" {
	create_duration = "5s"
	depends_on      = [module.lacework_cfg_svc_account]
}

resource "lacework_integration_gcp_cfg" "default" {
	name           = var.lacework_integration_name
	resource_id    = local.resource_id
	resource_level = local.resource_level
	credentials {
		client_id      = local.service_account_json_key.client_id
		private_key_id = local.service_account_json_key.private_key_id
		client_email   = local.service_account_json_key.client_email
		private_key    = local.service_account_json_key.private_key
	}
	depends_on = [time_sleep.wait_5_seconds]
}
