# Release Notes
Another day, another release. These are the release notes for the version `v0.1.1`.

We are introducing three new modules for Azure Cloud:
* `ad_application` Creates an Azure Active Directory application
* `activity_log` Creates a Lacework Activity Log integration
* `config` Creates a Lacework Compliance integration

Here is an example of how to use these modules to create both, a Lacework Compliance
integration and Lacework Activity Log integration:
```hcl
provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/config?ref=tags/v0.1.1"
}

module "az_activity_log" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/activity_log?ref=tags/v0.1.1"

  use_existing_ad_application = true
  application_id              = module.az_config.application_id
  application_password        = module.az_config.application_password
  service_principal_id        = module.az_config.service_principal_id
}
```

## Refactor
* refactor: modules azure config, activity_log and ad_application (#67) (Salim Afiune)([133de8a](https://github.com/lacework/terraform-provisioning/commit/133de8a9be3316f03df752458a74e54e4089148b))
## Bug Fixes
* fix(gcp): use correct Service Account Email (#65) (Salim Afiune)([d4777a1](https://github.com/lacework/terraform-provisioning/commit/d4777a19e9d155f30c7f23de985ca5b91e296723))
