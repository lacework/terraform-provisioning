module "gcp_project_config" {
  source = "./modules/config"
}

module "gcp_project_audit_log" {
  source                       = "./modules/audit_log"
  bucket_force_destroy         = true
  use_existing_service_account = true
  service_account_name         = module.gcp_project_config.service_account_name
  service_account_private_key  = module.gcp_project_config.service_account_private_key
}
