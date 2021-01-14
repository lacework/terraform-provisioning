module "gcp_project_config" {
  source  = "lacework/config/gcp"
  version = "~> 0.1.1"
}

module "gcp_project_audit_log" {
  source  = "lacework/audit-log/gcp"
  version = "~> 0.1.1"

  bucket_force_destroy         = true
  use_existing_service_account = true
  service_account_name         = module.gcp_project_config.service_account_name
  service_account_private_key  = module.gcp_project_config.service_account_private_key
}
