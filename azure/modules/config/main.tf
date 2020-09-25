locals {
  application_id       = var.use_existing_ad_application ? var.application_id : module.az_cfg_ad_application.application_id
  application_password = var.use_existing_ad_application ? var.application_password : module.az_cfg_ad_application.application_password
}

module "az_cfg_ad_application" {
  source                      = "../ad_application"
  create                      = var.use_existing_ad_application ? false : true
  application_name            = var.application_name
  application_identifier_uris = var.application_identifier_uris
  subscription_ids            = var.subscription_ids
  all_subscriptions           = var.all_subscriptions
  key_vault_ids               = var.key_vault_ids
  tenant_id                   = var.tenant_id
  password_length             = var.password_length
}

# wait for X seconds for the Azure resources to be created
resource "time_sleep" "wait_time" {
  create_duration = var.wait_time
  depends_on      = [module.az_cfg_ad_application]
}

resource "lacework_integration_azure_cfg" "default" {
  name      = var.lacework_integration_name
  tenant_id = module.az_cfg_ad_application.tenant_id
  credentials {
    client_id     = local.application_id
    client_secret = local.application_password
  }
  depends_on = [time_sleep.wait_time]
}
