provider "azuread" {}

provider "azurerm" {
  features {}
}

module "ad_application" {
  source = "../../"
}
