provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_config" {
  source                      = "../../"
  application_name            = "lacework_custom_ad_application_name"
  application_identifier_uris = ["https://account.lacework.net"]
  key_vault_ids               = ["vault-id-1", "vault-id-2", "vault-id-3", "vault-id-4"]
  subscription_ids            = ["subscription-id-1", "subscription-id-2", "subscription-id-3"]
  tenant_id                   = "123abc12-abcd-1234-abcd-abcd12340123"
  lacework_integration_name   = "a custom name"
  password_lenght             = 16
}
