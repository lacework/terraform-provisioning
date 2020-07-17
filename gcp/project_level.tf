provider "google" {}

provider "lacework" {}

module "gcp_project_config" {
	source = "https://github.com/lacework/terraform-provisioning/gcp/modules/config"
}

module "gcp_project_audit_log" {
	source                       = "https://github.com/lacework/terraform-provisioning/gcp/modules/audit_log"
	bucket_force_destroy         = true
	use_existing_service_account = true
	service_account_name         = module.gcp_project_config.service_account_name
}
