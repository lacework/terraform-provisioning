# GCP Provisioning - Step By Step
This document describes the step-by-step process to connect Lacework with Google Cloud. This code
creates the required resources on either an ORGANIZATION level, or per PROJECT level access for GCP
configuration assessment, as well as GCP Audit Trail analysis.

## Requirements
- Terraform `v.0.12.x`
- [GCP Service Account](https://cloud.google.com/iam/docs/service-accounts)
- [Lacework API Key](https://support.lacework.com/hc/en-us/articles/360011403853-Generate-API-Access-Keys-and-Tokens) 

## Organziation Integration
The following section covers how to use Terraform to integrate GCP configuration assessment and Audit Trail for an entire GCP Organization

### Setup GCP Service Account
In order to integrate Lacework with a GCP Organization you will need a GCP service account with the following permissions:
- Organziation Admin
- Logs Configuration Writer

Download the service account `json` file to your workstation and move on to the next section.

More information on how to download a GCP service account key can be found [here](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

### Run Terraform
1. Clone this repository: https://github.com/lacework/terraform-provisioning
2. Change directories into `terraform-provisioning/gcp`
3. Create a new file called `terraform.tfvars` with the following content:

```
credentials_file    = "<PATH TO GCP CREDENTIAL JSON FILE>"
org_integration     = true
organization_id     = "<GCP_ORG_ID>"
project_id          = "<GCP_PROJECT_ID>"
prefix              = "<name you want prefixed to resources provisioned>"
audit_log           = true
lacework_account    = "<YOUR LACEWORK ACCOUNT>"
lacework_api_key    = "<THE API KEY FROM LACEWORK JSON FILE>"
lacework_api_secret = "<THE API SECRET FROM LACEWORK JSON FILE>"
lacework_integration_config_name   = "<NAME FOR THIS INTEGRATION>"
lacework_integration_auditlog_name = "<NAME FOR THIS INTEGRATION>"
```
or use environment variables to avoid hardcoding API keys and secrets.

```
export TF_VAR_lacework_api_key=<THE API KEY FROM LACEWORK JSON FILE>
export TF_VAR_lacework_api_secret=<THE API SECRET FROM LACEWORK JSON FILE>
```
 
5. Run `terraform init`
6. Run `terraform apply`

More information on adding GCP credentials for Terraform can be found [here](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials)

## GCP Project Integration
The following section covers how to use Terraform to integrate GCP configuration assessment and Audit Trail on a per project basis. 

### Setup GCP Service Account
In order to integrate Lacework with a GCP Project you will need a GCP service account in each project you intend to integrate with the following permissions:
- Project Admin

Download the service account `json` file to your workstation and move on to the next section.

More information on GCP sevice accounts can be found [here](https://cloud.google.com/iam/docs/service-accounts)

### Run Terraform
1. Clone this repository: https://github.com/lacework/terraform-provisioning
2. Change directories into `terraform-provisioning/gcp`
3. Create a new file called `terraform.tfvars` with the following content:

```
credentials_file    = "<PATH TO GCP CREDENTIAL JSON FILE>"
organization_id     = "<GCP_ORG_ID>"
project_id          = "<GCP_PROJECT_ID>"
prefix              = "<name you want prefixed to resources provisioned>"
audit_log           = true
lacework_account    = "<YOUR LACEWORK ACCOUNT>"
lacework_api_key    = "<THE API KEY FROM LACEWORK JSON FILE>"
lacework_api_secret = "<THE API SECRET FROM LACEWORK JSON FILE>"
lacework_integration_config_name   = "<NAME FOR THIS INTEGRATION>"
lacework_integration_auditlog_name = "<NAME FOR THIS INTEGRATION>"
```
or use environment variables to avoid hardcoding API keys and secrets.

```
export TF_VAR_lacework_api_key=<THE API KEY FROM LACEWORK JSON FILE>
export TF_VAR_lacework_api_secret=<THE API SECRET FROM LACEWORK JSON FILE>
```
 
5. Run `terraform init`
6. Run `terraform apply`

More information on adding GCP credentials for Terraform can be found [here](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials)
