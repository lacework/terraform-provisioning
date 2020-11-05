# Integrate Azure with Lacework using Terraform
Lacework integrates with Microsoft Azure to monitor Activity Logs and cloud resource configurations for designated tenants and subscriptions. This document covers how to integrate Microsoft Azure and Lacework using Terraform.

In order for Lacework to monitor Microsoft Azure, the following resources need to be provisioned:

**Azure AD Application** - An Azure AD Application must be configured to integrate Lacework and Azure. The Azure AD Application is configured with the following permissions for Lacework:
* Active Directory Graph - Read access
* Azure Storage
* Microsoft Graph
* Azure Key Vault (optional)

## Running Lacework Terraform Modules for Microsoft Azure
There are two approaches for running Lacework Terraform modules to integrate Microsoft Azure with Lacework:

### Azure Cloud Shell
This approach uses [Azure Cloud Shell](https://shell.azure.com/) to run Terraform, which is already installed by default in Cloud Shell. Azure Cloud Shell inherits the permissions of the person logged in that launches Cloud Shell, which means Terraform will inherit those same permissions. 

This approach is suitable for one-off integrations where the user does not plan to continue to use Terraform to manage Lacework and Azure Cloud, or store the state in source control.

For instructions on using Azure Cloud Shell to run Lacework Terraform modules click [here](integrate_azure_using_azure_cloud_shell.md)

### Terraform installed on any supported host
In this approach, Terraform is installed, configured, and run from any supported system (Linux/macOS/Windows) and leverages a user account with required permissions to administer Azure using Terraform. 

This approach is suitable for companies that store Terraform code in source control, and plan to continue to manage the state of the integration between Lacework and Azure going forward.

For instructions on how to run Lacework Terraform modules from any supported platform click [here](integrate_gcp_using_supported_system.md)


## Use your Azure Portal

This couldn't be easier!

Follow [these instructions](AZURE_CLOUD_SHELL.md) to use the Azure Cloud Shell to run these modules from the comfort of your Azure Portal.

## Requirements
If you prefer to use these modules locally, you must meet the following requirements:

- [Terraform](terraform.io/downloads.html) - >= `0.12.x`, ~> `0.13.x
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Azure User](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory) with the following permissions:
  - *Global Administrator* privileges in Active Directory
  - *Owner Role* at the Subscription level
- [Lacework API Key](https://support.lacework.com/hc/en-us/articles/360011403853-Generate-API-Access-Keys-and-Tokens) 

It is recommended that the [Lacework CLI](https://github.com/lacework/go-sdk/wiki/CLI-Documentation) is installed and the `[default]` profile is associated with the applicable Lacework Account `api_key` and `api_secret` inside the `~/.lacework.toml` configuration file.

## Log in via the Azure CLI
In order to integrate Lacework with Azure you will need to log in to your Azure console via
the Azure CLI by running the command:
```
$ az log in
```

## Usage

**IMPORTANT:** We use the `master` branch in source just as an example. In your code, **do NOT pin to master** because there may
be breaking changes between releases. Instead we recommend to pin to the release tag (e.g. `?ref=tags/v0.1.0`) of one of
our [latest releases](https://github.com/lacework/terraform-provisioning/releases).


### Enable New Azure Compliance and Activity Log Integrations
```hcl
provider "azuread" {}

provider "azurerm" {
  version = "2.26"
  features {}
}

provider "lacework" {}

module "az_config" {
  source  = "lacework/config/azure"
  version = "0.1.0"
}

module "az_activity_log" {
  source  = "lacework/activity-log/azure"
  version = "0.1.0""

  use_existing_ad_application = true
  application_id              = module.az_config.application_id
  application_password        = module.az_config.application_password
  service_principal_id        = module.az_config.service_principal_id
}
```

### Validate The Configuration

Once Terraform finishes applying changes, you can use the Lacework CLI or the UI to confirm the integration is working. 

For the CLI open a Terminal and run `lacework integrations list` (you should see the two `AZURE_CFG` and `AZURE_AL_SEQ` Integrations listed)

To validate the integration via the UI, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts*
