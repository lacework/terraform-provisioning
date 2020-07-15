locals {
	resource_level        = var.org_integration ? "ORGANIZATION" : "PROJECT"
	resource_id           = var.org_integration ? var.organization_id : module.lacework_svc_account.project_id
	service_account_name  = var.use_existing_service_account ? var.service_account_name : (
		length(var.service_account_name) > 0 ? var.service_account_name : "lacework-svc-account"
	)
}

module "lacework_svc_account" {
	source               = "../service_account"
	create               = var.use_existing_service_account ? false : true
	service_account_name = local.service_account_name
	org_integration      = var.org_integration
	organization_id      = var.organization_id
	project_id           = var.project_id
}

data "null_data_source" "lacework_service_account_private_key" {
	inputs = {
		json = base64decode(module.lacework_svc_account.private_key)
	}
}

# wait for 5 seconds for things to settle down in the GCP side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_5_seconds" {
	create_duration = "5s"
	depends_on      = [data.null_data_source.lacework_service_account_private_key]
}

resource "lacework_integration_gcp_cfg" "default" {
	name           = var.lacework_integration_name
	resource_id    = local.resource_id
	resource_level = local.resource_level
	credentials {
		client_id      = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).client_id
		private_key_id = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).private_key_id
		client_email   = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).client_email
		private_key    = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).private_key
	}
	depends_on = [time_sleep.wait_5_seconds]
}
