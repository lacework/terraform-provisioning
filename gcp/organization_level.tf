provider "google" {}

provider "lacework" {}

module "gcp_organization_config" {
	source          = "https://github.com/lacework/terraform-provisioning/gcp/modules/config"
	org_integration = true
	organization_id = "my-organization-id"
}

module "gcp_organization_audit_log" {
	source                       = "https://github.com/lacework/terraform-provisioning/gcp/modules/audit_log"
	bucket_force_destroy         = true
	org_integration              = true
	use_existing_service_account = true
	service_account_name         = module.gcp_project_config.service_account_name
	service_account_private_key  = module.gcp_project_config.service_account_private_key
	organization_id              = "my-organization-id"
}
