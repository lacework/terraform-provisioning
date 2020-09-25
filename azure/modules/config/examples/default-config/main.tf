provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_config" {
  source = "../../"
}
