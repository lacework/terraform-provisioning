# Integrate AWS with Lacework Using Terraform
In order to integrate AWS accounts into Lacework for CloudTrail Analysis and Configuration Assessments, Lacework requires the following resources:

- **IAM Cross Account Role** - A cross account role is required to give access to Lacework access for assessments of cloud resource configurations and for analysis of CloudTrail events. The cross account role will be given the following policies:
  - [SecurityAudit](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_security-auditor) - AWS Managed Policy to provide read-only access to cloud resource configurations 
  - Lacework Custom IAM Policy - A custom policy that provides Lacework read-only access to injest CloudTrail logs
- **CloudTrail** - Lacework can create a new trail or use an existing CloudTrail
- **S3 Bucket** - An S3 bucket is required for all CloudTrail integrations. Lacework can use an existing bucket or create a new bucket in the designated account
- **SNS Topic** - An SNS topic is required for all CloudTrail integrations. Terraform can use an existing SNS topic or create one if an SNS topic has not be added to an existing CloudTrail
- **SQS Queue** - An SQS queue is required for all CloudTrail integrations and monitored by Lacework. 

Lacework maintains a set of Terraform modules that automates the process of provisioning and configuring all of the required resources in both the customer’s AWS account and the Lacework platform. 

### Requirements
- **AWS Account Admin** - The account used to run Terraform must have admin privileges on every AWS account you intend to integrate with Lacework 
- **AWS CLI** - AWS CLI must be configured with API Keys to the account you want to integrate
- **Lacework CLI** - Configured for any accounts you want to integrate with Lacework 
- **Terraform** - >= 0.12.24, ~> 0.13.x

## Overview of Deployment Scenarios
Lacework’s Terraform Modules for AWS support the following deployment scenarios:

- **Deploy New CloudTrail and Add Configuration Assessment** - This deployment scenario will configure a new CloudTrail in an AWS account, Configure an AWS account for cloud resource configuration assessment, and integrate the AWS account with Lacework
- **Integrate Existing CloudTrail and add Configuration Assessment** - This deployment scenario uses an existing CloudTrail, S3 bucket, and can create a new or use an existing SNS topic passed as inputs to the module. The example creates the SQS queue and IAM Role for Lacework, and then configures both integrations with Lacework
- **New Consolidated CloudTrail** - This scenario enables a new Consolidated CloudTrail and IAM Role for Lacework, then configures both integrations with Lacework. Finally, it configures a new CloudTrail Trail in an AWS sub-account that points to the main CloudTrail
- **Existing Consolidated CloudTrail** - This scenario uses an Consolidated CloudTrail and creates an IAM Role for Lacework, then configures all sub accounts to be integrated with Lacework

### Scenario 1 - Deploy New CloudTrail, and Add Configuration Assessment
In this scenario a new CloudTrail will be created in an AWS account along with a cross-account IAM role to provide Lacework access to monitor CloudTrail, AWS resource configurations, and integrate the AWS account into Lacework. 

1. Ensure you have have the Lacework CLI [installed and configured](https://github.com/lacework/go-sdk/wiki/CLI-Documentation#configuration) to the Lacework account you plan to integrate
2. Open an EDITOR of choice ([VSCode](https://code.visualstudio.com/download), [Atom](https://atom.io/), or VIM) and create a new file called `main.tf`
3. Copy the following code snippet and paste it into the `main.tf` file:


```
provider "aws" {}

provider "lacework" {}

module "aws_config" {
  source  = "lacework/config/aws"
  version = "0.1.1"
}

module "aws_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0

  bucket_force_destroy  = true
  use_existing_iam_role = true
  iam_role_name         = module.aws_config.iam_role_name
  iam_role_arn          = module.aws_config.iam_role_arn
  iam_role_external_id  = module.aws_config.external_id
}
```
5. Lacework modules have various inputs that can be used to customize the configuration of the integration. If you need to customize any of the configuration for this integration such as the S3 bucket name, the prefix for resources created, or add settings such as encryption for your bucket you can check out the full list of inputs for the modules on the Terraform Registry [documentation site](https://registry.terraform.io/search/modules?provider=aws&q=lacework).
6. Open a Terminal and change directories to the directory that contains the `main.tf` and run `terraform init` to initialize the project and download the required modules.
7. Run `terraform plan` to validate the configuration and review pending changes.
8. When you have reviewed the pending changes run `terraform apply` to execute changes.

#### Validate The Configuration

Once Terraform finishes applying changes, you can use the Lacework CLI or the Lacework Console to confirm the integration is working. 

For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the Lacework Console, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts**

## Scenario 2 - Integrate Existing CloudTrail and add Configuration Assessment
In this scenario Terraform configures a cross-account IAM role to provide Lacework access to monitor an existing CloudTrail. That same cross-account role also provides Lacework permissions to audit AWS resource configurations, and integrate the AWS account into Lacework. An SQS queue will be created for Lacework, and optionally you can deploy an SNS topic for that SQS queue if one does not already exist.

*Note: Must be run from the account that owns the S3 bucket used with the cloudtrail*

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice ([VSCode](https://code.visualstudio.com/download), [Atom](https://atom.io/), or VIM) and create a new file called `main.tf`
3. Copy the following code snippet and paste it into the main.tf file:

```hcl
provider "aws" {
  region = "<region of existing CloudTrail>"
}

provider "lacework" {}

module "aws_config" {
  source  = "lacework/config/aws"
  version = "0.1.1"
}

module "aws_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0

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

#### Validate The Configuration

Once Terraform finishes, you can use the CLI or the Lacework Console to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the Lacework Console, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts**

## Scenario 3 -  Deploy New Consolidated CloudTrail and Configuration Assessment
Lacework supports the integration of consolidated CloudTrail deployments where multiple sub accounts send CloudTrail logs to a master CloudTrail account.

This scenario enables a organization CloudTrail and a cross-account IAM role to give Lacework access to CloudTrail and integrates the AWS accounts into Lacework.

For more information on organziation level CloudTrail deployments visit AWS documentation site [here](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ct.html)

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice ([VSCode](https://code.visualstudio.com/download), [Atom](https://atom.io/), or VIM) and create a new file called `main.tf`
3. Copy the following code snippet and paste it into the main.tf file:

```hcl
provider "lacework" {}

provider "aws" {
  alias = "main"
}

module "aws_config_main" {
  source  = "lacework/config/aws"
  version = "0.1.1"

  providers = {
    aws      = aws.main
  }
}

module "main_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0"

  providers = {
    aws      = aws.main
  }
  consolidated_trail = true
}

provider "aws" {
  alias = "sub_account"
}

module "aws_config_sub_account" {
  source  = "lacework/config/aws"
  version = "0.1.1"

  providers = {
    aws      = aws.sub_account
  }
}

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0"

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

#### Validate The Configuration

Once Terraform finishes, you can use the CLI or the Lacework Console to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the Lacework Console, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts**

## Scenario 4 - Integrate Existing Consolidated CloudTrail and Configuration Assessment
Lacework supports the integration of consolidated CloudTrail deployments where multiple sub accounts send CloudTrail logs to a master CloudTrail account.

This scenario uses an existing consolidated CloudTrail, and deploys a cross-account IAM role to give Lacework access to CloudTrail and integrates the AWS accounts into Lacework. The cross account role also provides Lacework access to assess cloud resource configurations.

For more information on organziation level CloudTrail deployments visit AWS documentation site [here](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-ct.html)

1. Ensure you have have the Lacework CLI installed and configured to the Lacework account you plan to integrate
2. Open an EDITOR of choice (VS Code, Atom, Sublime, VIM) and create a new file called main.tf
3. Copy the following code snippet and paste it into the main.tf file:

```hcl
provider "lacework" {}

provider "aws" {
  alias = "main"
}

module "aws_config_main" {
  source  = "lacework/config/aws"
  version = "0.1.1"

  providers = {
    aws      = aws.main
  }
}

module "main_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0"

  providers = {
    aws      = aws.main
  }
  consolidated_trail = true
}

provider "aws" {
  alias = "sub_account"
}

module "aws_config_sub_account" {
  source  = "lacework/config/aws"
  version = "0.1.1"

  providers = {
    aws      = aws.sub_account
  }
}

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "0.1.0"

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

#### Validate The Configuration

Once Terraform finishes, you can use the CLI or the Lacework Console to confirm the integration is working. For the CLI open a Terminal and run `lacework integrations list` (you will see the two AWS CloudTrail and AWS Configuration Integrations listed)

To validate the integration via the Lacework Console, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts**

