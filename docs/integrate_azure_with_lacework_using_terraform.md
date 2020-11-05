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

For instructions on how to run Lacework Terraform modules from any supported platform click [here](integrate_azure_using_supported_system.md)