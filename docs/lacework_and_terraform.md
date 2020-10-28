# Managing Lacework Integrations and Configuration with Hashicorp Terraform
For companies who have adopted Terraform for automation within their organization, Lacework maintains two open source projects to support managing Lacework organizations and accounts as code including the integrations with AWS, GCP, and Azure cloud environments. The two projects are:

- [**Lacework Terraform Provider**](https://github.com/terraform-providers/terraform-provider-lacework) - A collection of custom Terraform resources for managing the configuration of Lacework accounts including Cloud Accounts, Alert Channels, Container Registries, and more

- [**Terraform Provisioning**](https://github.com/lacework/terraform-provisioning) - A collection of Terraform Modules for AWS, GCP, and Azure that manages the integrations between Lacework accounts and customer public cloud accounts

## Before you begin
It is important to keep in mind that when using the Terraform Modules from Lacework with ANY of the supported public clouds, you will need to have permissions for yourself or a designated service account to provision resources in your cloud accounts. 

If you are using custom resources from the Terraform Provider for Lacework, you will need to have an API Key. The easiest way to configure the Terraform Provider for Lacework is by leveraging the configuration from the Lacework Command Line Interface (CLI)

### Terraform Provider for Lacework and The Lacework CLI
The Terraform Provider for Lacework has the ability to leverage configuration from Lacework CLI. Once the Lacework CLI is installed and configured on the system that you plan to run Terraform on you can leverage any profile stored. 

The following example shows how you can use two different configurations from the Lacework CLI...


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

It is highly recommended you install and configure the Lacework CLI when using the Terraform Provider for Lacework. For more information on installing/configuring the Lacework CLI visit the documentation [here](https://github.com/lacework/go-sdk/wiki/CLI-Documentation#installation)

## Terraform to manage integrations with public cloud accounts and Lacework

The following sections describe in detail the steps you will need to follow to use Terraform to integrate public cloud accounts with Lacework for configuration assessments, and for AWS CloudTrail, GCP Audit Log, and Azure Activity Log analysis.

- [Integrate AWS with Lacework using Terraform]()
- [Integrate Google Cloud Platform with Lacework using Terraform]()
- [Integrate Microsoft Azure with Lacework using Terraform]()
- [Integrate Microsoft Azure with Lacework using Terraform and the Azure Cloud Shell]()
- [Manage Alert Channels in Lacework using Terraform]()
- [Manage Integrations with Container Registries using Terraform]()


