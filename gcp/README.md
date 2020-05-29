# GCP Provisioning - Step By Step
This document describes the step-by-step process to connect Lacework with Google Cloud. This code
creates the required resources on either an ORGANIZATION level, or per PROJECT level access for GCP
configuration assessment, as well as GCP Audit Trail analysis.

## Requirements
- Terraform `v.0.12.x`
- [GCP Service Account](https://cloud.google.com/iam/docs/service-accounts) with the following permissions
  - **ORGANIZATION OWNER** (for organization level integration)
  - **PROJECT OWNER** (for project level integration)
- [Lacework API Key](https://support.lacework.com/hc/en-us/articles/360011403853-Generate-API-Access-Keys-and-Tokens) 

## Step-By-Step
1. Clone this repository: https://github.com/lacework/terraform-provisioning
2. Download the compiled Lacework Terraform Provider for the platform you are running and place it at `~/.terraform.d/plugins/terraform-provider-lacework`

| Platform | 64-bit  |  32-bit  |
|---|---|---|
| MacOS (Darwing) | [`amd64`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-darwin-amd64) | [`i386`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-darwin-386)|
| Linux | [`amd64`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-linux-amd64) | [`i386`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-linux-386)|
| Windows | [`amd64`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-windows-amd64.exe)| [`i386`](https://techally-content.s3-us-west-1.amazonaws.com/terraform-provider-lacework/terraform-provider-lacework-windows-386.exe)|

_NOTE: This is a temporary step until HashiCorp has released the Lacework Terraform Provider_

3. Change directories into `terraform-provisioning/gcp`
4. Create a new file called `terraform.tfvars` with the following content:

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

5. Run `terraform init`
6. Run `terraform apply`

More information on adding GCP credentials for Terraform can be found [here](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials)
