provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_activity_log" {
  source = "../../"
}
