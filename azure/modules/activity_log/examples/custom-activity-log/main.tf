provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_activity_log" {
  source                      = "../../"
  application_identifier_uris = ["https://account.lacework.net"]
  application_name            = "my-custom-application-name"
  key_vault_ids               = ["vault-id-1", "vault-id-2", "vault-id-3", "vault-id-4"]
  tenant_id                   = "123abc12-abcd-1234-abcd-abcd12340123"
  password_lenght             = 16
  lacework_integration_name   = "custom name"
  prefix                      = "customprefix"
  location                    = "Central US"
}
