# Managing Lacework Integrations and Configuration with Hashicorp Terraform
For companies who have adopted Terraform for automation within their organization, Lacework maintains a [Terraform Provider for Lacework](https://registry.terraform.io/providers/lacework/lacework/latest) and a collection of [Terraform modules](https://registry.terraform.io/search/modules?q=lacework) on HashiCorp's [Terraform Registry](https://registry.terraform.io/) to help Lacework customers manage the configuration of Lacework as code, and to automate the integration of their public public cloud environments with Lacework using Terraform automation. 

The following sections cover everything you will need to know to get started with Terraform and Lacework, for any of the supported public cloud providers.

## Before you begin
It is important to keep in mind that when using the Terraform Modules from Lacework with ANY of the supported public clouds, you will need to have permissions for yourself or a designated service account to provision resources in your cloud accounts. 

When using custom resources from the Terraform Provider for Lacework, you will need to have an API Key. The easiest way to configure the Terraform Provider for Lacework is by leveraging the configuration from the [Lacework Command Line Interface (CLI)](https://github.com/lacework/go-sdk/wiki/CLI-Documentation)

### Terraform Provider for Lacework and The Lacework CLI
The Terraform Provider for Lacework has the ability to leverage configuration from the Lacework CLI. Once the Lacework CLI is installed and configured on the system that you plan to run Terraform on you can leverage any profile stored. 

The following example shows how you can use two different configurations from the Lacework CLI:


```lacework.toml
# Example lacework.toml - Config for Lacework CLI

[default]
  account = "main-account"
  api_key = "MAIN_3B3E14535E093681ED0DEBDC94C884FF6413242H2G5UDFF"
  api_secret = "_8e52ee492fceb0cd49b4f789bhskljhfds"

[sub-account]
  account = "sub-account"
  api_key = "SUB_20255A108A0C43A512AFA75CC0DA4C60688DBKJSDFLK55"
  api_secret = "_fbf8d6640295b24aecd3chhsai27"
```

```hcl
provider "lacework" {
  # This uses the API key and secret for the default profile
}

provider "lacework" {
  # This uses the API key and secret for the sub-account profile
  profile = "sub-account"
}
```

It is highly recommended you install and configure the Lacework CLI when using the Terraform Provider for Lacework. For more information on installing and configuring the Lacework CLI visit the documentation [here](https://github.com/lacework/go-sdk/wiki/CLI-Documentation#installation)

## Terraform to manage integrations with public cloud accounts and Lacework

The following sections describe in detail the steps you will need to follow to use Terraform to integrate public cloud accounts with Lacework for configuration assessments, and for AWS CloudTrail, Google Cloud Audit Log, and Azure Activity Log analysis.
- [Integrate AWS with Lacework using Terraform](integrate_aws_with_lacework_using_terraform.md)
- [Integrate Google Cloud Platform with Lacework using Terraform](integrate_gcp_with_lacework_using_terraform.md)
- [Integrate Microsoft Azure with Lacework using Terraform](integrate_azure_with_lacework_using_terraform.md)
