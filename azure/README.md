# Azure Provisioning - Step By Step
This document describes the step-by-step process to connect Lacework with Azure Cloud. This code
creates the required resources for Azure Compliance assessment, as well as Azure Activity Log
Trail analysis.

## Requirements
- Terraform `v.0.12.x`
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Azure User](https://cloud.google.com/iam/docs/service-accounts) with the following permissions:
  - *Global Administrator* privileges in Active Directory
  - *Owner Role* at the Subscription level
- [Lacework API Key](https://support.lacework.com/hc/en-us/articles/360011403853-Generate-API-Access-Keys-and-Tokens) 

Also recommend that the [Lacework CLI](https://github.com/lacework/go-sdk/wiki/CLI-Documentation) be installed and the `[default]` profile is associated with the applicable Lacework Account `api_key` and `api_secret` in `~/.lacework.toml`

## Login via the Azure CLI
In order to integrate Lacework with Azure you will need to login to your Azure console via
the Azure CLI by running the command:
```
$ az login
```

## Usage

**IMPORTANT:** We use the `master` branch in source just as an example. In your code, **do NOT pin to master** because there may
be breaking changes between releases. Instead we recommend to pin to the release tag (e.g. `?ref=tags/v0.1.0`) of one of
our [latest releases](https://github.com/lacework/terraform-provisioning/releases).


### Enable New Azure Compliance and Activity Log Integrations
```hcl
provider "azuread" {}

provider "azurerm" {
  features {}
}

provider "lacework" {}

module "az_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/config?ref=master"
}

module "az_activity_log" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/activity_log?ref=master"

  use_existing_ad_application = true
  application_id              = module.az_config.application_id
  application_password        = module.az_config.application_password
  service_principal_id        = module.az_config.service_principal_id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application_name | The name of the Azure Active Directory Applicaiton | `string` | lacework_security_audit | no |
| application_identifier_uris | A list of user-defined URI(s) for the Lacework AD Application | `list(string)` | ["https://securityaudit.lacework.net"] | no |
| key_vault_ids | A list of Key Vault Ids used in your subscription for the Lacework AD App to have access to | `list(string)` | [] | no |
| tenant_id | A Tenant ID different from the default defined inside the provider | `string` | "" | no |
| password_length | The length of the Lacework AD Application password | `number` | 30 | no |
| use_existing_ad_application | Set this to true to use an existing Active Directory Application | `bool` | false | no |
| application_id | The Active Directory Application id to use (required when use_existing_ad_application is set to true) | `string` | "" | no |
| application_password | The Active Directory Application password to use (required when use_existing_ad_application is set to true) | `string` | "" | no |
| service_principal_id | The Service Principal id to use (required when use_existing_ad_application is set to true) | `string` | "" | no |
| prefix | The prefix that will be use at the beginning of every generated resource | `string` | l4c3w0rk | no |
| lacework_integration_name | The name of the integration in Lacework. This input is available in both the config, and the activity_log module | `string` | TF config | no |
| wait_time | Define a custom delay between cloud resource provision and Lacework external integration to avoid errors while things settle down. Use `10s` for 10 seconds, `5m` for 5 minutes. | `string` | `10s` | no |

## Outputs

| Name | Description |
|------|-------------|
| application_id | The Lacework AD Application id |
| application_password | The Lacework AD Application password |
| service_principal_id | The Lacework Service Principal id |
