# Integrating AWS with Lacework using HashiCorp Terraform
In order to integrate AWS accounts into Lacework for CloudTrail Analysis and Configuration Assessments, Lacework requires the following resources:

- IAM Cross Account Role - A cross account role is required to give access to Lacework access for assessments of cloud resource configurations and for analysis of CloudTrail events. The cross account role will be given the following policies:
  - SecurityAudit - AWS Managed Policy to provide read-only access to cloud resource configurations 
  - Lacework Custom IAM Policy - A [custom policy]() that provides Lacework read-only access to pull CloudTrail logs
- CloudTrail - Lacework can create a new trail or use an existing
- S3 Bucket - This is required for all CloudTrail integrations. Lacework can use an existing bucket or create a new bucket in the designated account
- SNS Topic - An SNS topic is required for all CloudTrail integrations. Terraform can use an existing SNS topic or create one if an SNS topic has not be added to an existing CloudTrail
- SQS Queue - An SQS queue is required for all CloudTrail integrations and monitored by Lacework. 

Lacework maintains a set of Terraform modules that automates the process of provisioning and configuring all of the required resources in both the customer’s AWS account and the Lacework platform. 

### Requirements
- AWS Account Admin - The account used to run Terraform must have admin privileges on every AWS account you intend to integrate with Lacework 
- AWS CLI - AWS CLI must be configured with API Keys to the account you want to integrate
- Lacework CLI - Configured for any accounts you want to integrate with Lacework 
- Terraform v.0.12.x, v.0.13.x

Note: It is highly recommended that you store your Terraform configuration in a source control management solution such as [Git].

## Overview of Deployment Scenarios
Lacework’s Terraform Modules for AWS support the following deployment scenarios:

- **Deploy New CloudTrail and Add Configuration Assessment** - This deployment scenario will configure a new CloudTrail in an AWS account, Configure an AWS account for cloud resource configuration assessment, and integrate the AWS account with Lacework
- **Integrate Existing CloudTrail and add Configuration Assessment** - This deployment scenario uses an existing CloudTrail, S3 bucket, and can create a new or use an existing SNS topic passed as inputs to the module. The example creates the SQS queue and IAM Role for Lacework, and then configures both integrations with Lacework
- **New Consolidated CloudTrail** - This scenario enables a new Consolidated CloudTrail and IAM Role for Lacework, then configures both integrations with Lacework. Finally, it configures a new CloudTrail Trail in an AWS sub-account that points to the main CloudTrail
- **Existing Consolidated CloudTrail** - This scenario uses an Consolidated CloudTrail and creates an IAM Role for Lacework, then configures all sub accounts to be integrated with Lacework

### Scenario 1 - Deploy New CloudTrail, and Add Configuration Assessment
In this scenario a new CloudTrail will be created in an AWS environment along with a cross-account IAM role to provide Lacework access to monitor CloudTrail, AWS resource configurations, and integrate the AWS account into Lacework. 

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice (VS Code, Atom, Sublime, VIM) and create a new file called `main.tf`
3. Copy the following code snippet and paste it into the `main.tf` file:


```
provider "aws" {}

provider "lacework" {}

module "aws_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/config?ref=master"
}

module "aws_cloudtrail" {
  source                = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=tags/<VERSION>"
  bucket_force_destroy  = true
  use_existing_iam_role = true
  iam_role_name         = module.aws_config.iam_role_name
  iam_role_arn          = module.aws_config.iam_role_arn
  iam_role_external_id  = module.aws_config.external_id
}
```
5. If you need to customize any of the configuration for your this integration like S3 bucket name, the prefix for resources created, or add settings like encryption for your bucket you can check out the full list of inputs for the modules here.
6. Open a Terminal and change directories to the directory that contains the `main.tf` and run `terraform init` to initialize the project and download the required modules.
7. Run `terraform plan` to validate the configuration and review pending changes.
8. When you have reviewed the pending changes run `terraform apply` to execute changes


Once Terraform finishes applying changes, you can use the Lacework CLI or the UI to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the UI, Login to your account and go to Settings -> Integrations -> Cloud Accountss

## Scenario 2 - Integrate Existing CloudTrail and add Configuration Assessment
In this scenario Terraform configures a cross-account IAM role to provide Lacework access to monitor an existing CloudTrail. That same cross-account role also provides Lacework permissions to audit AWS resource configurations, and integrate the AWS account into Lacework. An SQS queue will be created for Lacework, and optionally you can deploy an SNS topic for that SQS queue if one does not already exist.

*Note: Must be run from the account that owns the S3 bucket used with the cloudtrail*

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice (VS Code, Atom, Sublime, VIM) and create a new file called main.tf
3. Copy the following code snippet and paste it into the main.tf file:

```hcl
provider "aws" {
  region = "<region of existing CloudTrail>"
}

provider "lacework" {}

module "aws_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/config?ref=master"
}

module "aws_cloudtrail" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"

  use_existing_cloudtrail = true
  bucket_arn              = "<YOUR EXISTING AWS BUCKET ARN>"
  bucket_name             = "<YOUR AWS BUCKETNAME>"

  use_existing_iam_role = true
  iam_role_name         = module.aws_config.iam_role_name
  iam_role_arn          = module.aws_config.iam_role_arn
  iam_role_external_id  = module.aws_config.external_id
}
```
4. Update the `bucket_arn` and `bucket_name`
5. If you have an existing SNS topic that you want to use add the input `sns_topic_name = <YOUR SNS TOPIC>`
6. If you need to customize any of the configuration for this integration like the prefix for resources created, or add settings like encryption for your bucket you can check out the full list of inputs for the modules here.
7. Open a Terminal and change directories to the directory that contains the `main.tf` and run `terraform init` to initialize the project and download the required modules
8. Run `terraform plan` to validate the configuration and review pending changes
9. When you have reviewed the pending changes run `terraform apply` to execute changes

Once Terraform finishes, you can use the CLI or the UI to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the UI, Login to your account and go to Settings -> Integrations -> Cloud Accounts

## Scenario 3 - Deploy Organization CloudTrail and Configuration Assessment
Lacework supports the integration of Organization level CloudTrail deployments where multiple sub accounts send CloudTrail logs to a master CloudTrail account.

This scenario enables a organization CloudTrail and a cross-account IAM role to give Lacework access to CloudTrail and integrates the AWS accounts into Lacework.

For more information on organziation level CloudTrail deployments visit AWS documentation site [here](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ct.html)

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice (VS Code, Atom, Sublime, VIM) and create a new file called main.tf
3. Copy the following code snippet and paste it into the main.tf file:

```hcl
provider "lacework" {
  alias = "main"
}

provider "aws" {
  alias = "main"
}

module "main_cloudtrail" {
  source    = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"
  providers = {
    aws      = aws.main
    lacework = lacework.main
  }
  consolidated_trail = true
}

provider "aws" {
  alias = "sub_account"
}

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
  provider              = aws.sub_account
  name                  = "lacework-sub-trail"
  is_multi_region_trail = true
  s3_bucket_name        = module.main_cloudtrail.bucket_name
  sns_topic_name        = module.main_cloudtrail.sns_arn
}
```

4. Update the `bucket_arn` and `bucket_name`
5. If you have an existing SNS topic that you want to use add the input `sns_topic_name = <YOUR SNS TOPIC>`
6. If you need to customize any of the configuration for this integration like the prefix for resources created, or add settings like encryption for your bucket you can check out the full list of inputs for the modules here.
7. Open a Terminal and change directories to the directory that contains the `main.tf` and run `terraform init` to initialize the project and download the required modules
8. Run `terraform plan` to validate the configuration and review pending changes
9. When you have reviewed the pending changes run `terraform apply` to execute changes

Once Terraform finishes, you can use the CLI or the UI to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the UI, Login to your account and go to Settings -> Integrations -> Cloud Accounts

