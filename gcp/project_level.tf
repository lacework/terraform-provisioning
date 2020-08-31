provider "google" {}

provider "lacework" {}

module "gcp_project_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/config?ref=master"
}

module "gcp_project_audit_log" {
  source                       = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/audit_log?ref=master"
  bucket_force_destroy         = true
  use_existing_service_account = true
  service_account_name         = module.gcp_project_config.service_account_name
}
