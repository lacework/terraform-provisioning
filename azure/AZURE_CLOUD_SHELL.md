# Azure Cloud Shell
The Azure Cloud Shell is an embedded terminal/command-line interface that can be used within the Azure
Portal. This shell automatically authenticates you with Azure AD and comes with tools like the Azure
CLI and Terraform pre-installed to manage and automate your Azure environment.

These instructions will show you how to get up-and-running with Lacework, Terraform and the Azure Cloud Shell.
The only requirement we need is that your [Azure User](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/add-users-azure-active-directory) has
the following permissions:
- **Global Administrator** privileges in Active Directory
- **Owner Role** at the Subscription level

## Open Azure Cloud Shell within Azure Portal
To open the Azure Cloud Shell, you simply click on the Cloud Shell icon in the header bar of the Azure Portal,
and it will open the Cloud Shell in a pane at the bottom of the browser. Cloud Shell defaults to PowerShell,
but you can also switch to a Bash prompt if you prefer.

![Open Azure Cloud Shell](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/azure-cloud-shell-open.png)

## Prepare your Cloud Shell

Regardless of the prompt you choose to use, Powershell or Bash, we will need to run the `shell_startup.sh`
script to install all the neccessary tools and configure some environment variables required by Terraform.

**NOTE:** Weather you are in Powershell or Bash you can run these commands.

```
PS /home/salim> curl https://raw.githubusercontent.com/lacework/terraform-provisioning/master/azure/shell_startup.sh | bash
```

Make sure to restart your shell before proceeding to the next step.

## Configure the Lacework CLI

Proceed to configure the Lacework CLI by using the command `lacework configure`. You will need three things:
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
connecting such resources to you Lacework account. To customize these modules look at the [following input
parameters](https://github.com/lacework/terraform-provisioning/tree/master/azure#inputs).

**IMPORTANT:** We use the `master` branch in source just as an example. In your code, **do NOT pin to master**
because there may be breaking changes between releases. Instead we recommend to pin to the release tag (e.g.
`?ref=tags/v0.1.0`) of one of our [latest releases](https://github.com/lacework/terraform-provisioning/releases).

```hcl
provider "azuread" {}

provider "azurerm" {
  version = "2.26"
  features {}
}

provider "lacework" {}

module "az_config" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/config?ref=master"
}

module "az_activity_log" {
  source = "git::https://github.com/lacework/terraform-provisioning.git//azure/modules/activity_log?ref=master"

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

Then, run `terraform apply`, this command will create a "plan" of the resources that will be created and stop
for you to type `yes` to proceed.
```
$ terraform apply
```

![Hit Yes](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/azure-cloud-shell-editor-terraform-apply.png)

**Hit yes!**

### Verify Lacework Integrations

To verify if the two integrations have been configured successfully, run the command:
```
$ lacework integrations list
```
