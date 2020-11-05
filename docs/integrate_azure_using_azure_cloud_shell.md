# Integrate Azure and Lacework Using Azure Cloud Shell
The Azure Cloud Shell is an embedded terminal/command-line interface that can be used within the Azure Portal. This shell automatically authenticates the user that launches Cloud Shell with Azure AD and comes with tools pre-installed such as the Azure CLI and Terraform to manage and automate your Azure environment.

These instructions cover how to get up-and-running with Lacework, Terraform and the Azure Cloud Shell.

## Requirements
The only requirement needed is the [Azure User](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory) has the following permissions:

- **Global Administrator** privileges in Active Directory
- **Owner Role** at the Subscription level

## Open Azure Cloud Shell within Azure Portal
To open the Azure Cloud Shell, click on the Cloud Shell icon in the header bar of the Azure Portal, and it will open the Cloud Shell in a pane at the bottom of the browser. Cloud Shell defaults to PowerShell, but also supports a Bash prompt if preferred.

![Open Azure Cloud Shell](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/azure-cloud-shell-open.png)

## Install and Configure the Lacework CLI in Azure Cloud Shell

The Terraform Provider for Lacework leverages configuration from the Lacework CLI to authenticate with Lacework's API server to configure accounts. Lacework has created a shell script to install the Lacework CLI to Azure Cloud Shell.

### Install the Lacework CLI Using the shell_startup.sh Script

Open Cloud Shell and run the following command:

```
curl https://raw.githubusercontent.com/lacework/terraform-provisioning/master/azure/shell_startup.sh | bash
```

When the script completes, type `exit` followed by hitting the **ENTER** key to exit your shell. After a few seconds a prompt will appear to reconnect to Azure Shell. Once reconnected, the Lacework CLI will be ready for use. 

### Configure the Lacework CLI

Proceed to configure the Lacework CLI by using the command `lacework configure`. The  need three things:
* `account`: Account subdomain of URL (i.e. `<ACCOUNT>.lacework.net`)
* `api_key`: API Access Key
* `api_secret`: API Access Secret

>To create a set of API keys, log in to your Lacework account via WebUI and navigate to Settings > API Keys and
>click + Create New. Enter a name for the key and an optional description, then click Save. To get the secret key,
>download the generated API key file.

The Azure Cloud Shell allows you to drag-and-drop the generated `KEY.json` to upload it automatically.

![Download-Drag-and-Drop Lacework API key](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/azure-cloud-shell-drag-drop-api-key.gif)

Finally, run the command:
```
$ lacework configure -j CUSTOMER_EED10DA9136E9F763477FF5933464DD0C3DADF2CDDEF715.json
▸ Account: customerdemo
▸ Access Key ID: CUSTOMER_EED10DA9136E9F763477FF5933464DD0C3DADF2CDDEF715
▸ Secret Access Key: (*****************************26a0)

You are all set!
```

For more information about the Lacework CLI, see https://github.com/lacework/go-sdk/wiki/CLI-Documentation.

## Enable Azure Compliance and Activity Log Integrations
Cloud Shell also has a built-in file editor that will give you a more graphically appealing experience for
editing files, use the following command to create a Terraform template named `main.tf`.
```
$ code main.tf
```

Inside this file add the following code snippet that will configure both, Azure Compliance and Activity Log
Integrations. The code leverages our Terraform modules to create resources in you Azure Portal as well as
connecting such resources to you Lacework account. To customize these modules look at the [following input parameters](https://github.com/lacework/terraform-provisioning/tree/master/azure#inputs).

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
  version = "0.1.0"

  use_existing_ad_application = true
  application_id              = module.az_config.application_id
  application_password        = module.az_config.application_password
  service_principal_id        = module.az_config.service_principal_id
}
```

__NOTE: Don't forget to save the file with `Ctrl + S` on Windows or `Cmd + S` on MacOS__

### Run the Automation. Run Terraform!

Run the command `terraform init` to download the necessary plugins and modules required to run this automation.
```
$ terraform init
```

Then, run `terraform apply`, this command will create a "plan" of the resources that will be created and stop for you to type `yes` to proceed.

```
$ terraform apply
```

![Hit Yes](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/azure-cloud-shell-editor-terraform-apply.png)

**Hit yes!**

### Validate The Configuration

Once Terraform finishes applying changes, you can use the Lacework CLI or the UI to confirm the integration is working. 

For the CLI open a Terminal and run `lacework integrations list` (you should see the two `AZURE_CFG` and `AZURE_AL_SEQ` Integrations listed)

To validate the integration via the UI, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts*
