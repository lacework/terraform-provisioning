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

## Login via the Azure CLI
In order to integrate Lacework with Azure you will need to login to your Azure console via
the Azure CLI by running the command:
```
$ az login
```

### Run Terraform
1. Clone this repository: https://github.com/lacework/terraform-provisioning
2. Change directories into `terraform-provisioning/azure`
3. Create a new file called `terraform.tfvars` with the following content:

```
prefix          = "<SHORT PREFIX TO IDENTIFY RESOURCES>"
identifier_uris = [
	"https://<YOUR LACEWORK ACCOUNT>.lacework.net"
]
lacework_account    = "<YOUR LACEWORK ACCOUNT>"
lacework_api_key    = "<THE API KEY FROM LACEWORK JSON FILE>"
lacework_api_secret = "<THE API SECRET FROM LACEWORK JSON FILE>"
```
or use environment variables to avoid hardcoding API keys and secrets.

```
export TF_VAR_lacework_api_key=<THE API KEY FROM LACEWORK JSON FILE>
export TF_VAR_lacework_api_secret=<THE API SECRET FROM LACEWORK JSON FILE>
```
 
5. Run `terraform init`
6. Run `terraform apply`
