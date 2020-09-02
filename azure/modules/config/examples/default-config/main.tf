provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {
  #profile = "mini"
}

module "az_config" {
  source = "../../"
  #application_identifier_uris = ["https://mini-ally.lacework.net"]
}
