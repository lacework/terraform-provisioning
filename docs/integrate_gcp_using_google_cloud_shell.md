# Integrate Google Cloud and Lacework using Google Cloud Shell
The following document covers integrating Google Cloud with Lacework using Terraform in Google Cloud Shell. 

Google Cloud Shell is an embedded terminal/command-line interface that can be used within the Google Console. Google Cloud Shell assumes the permissions of the user launching Google Cloud Shell, and comes with tools pre-installed like the [Google Cloud SDK](https://cloud.google.com/sdk/gcloud/), `gcloud` command-line tool, and Terraform pre-installed to manage and automate your projects and resources in your environment.

Running Terraform from within Google Cloud Shell is more suitable for one-off integrations where the user does not plan to continue to use Terraform to manage the configuration of Lacework and Google Cloud. 

If you plan to continue to manage the state of the integration between Google Cloud and Lacework, and/or store the state of the configuration in a source control management tool such as Git, review the following documentation [here](integrate_gcp_using_supported_system.md).

## Before You Begin
Google Cloud Shell inherits the permissions of the user running Cloud Shell. Before you begin, decide whether you are going to integrate GCP at an Organzation Level, or a per Project level, and then ensure your user account has the following permissions:

* **Organization Level Integrations**
	- `roles/owner` - For an Organization level integration it is recommended to create a dedicated Google Cloud Project to contain the required resources. The user account used to run Google Cloud Shell must have 'OWNER' permissions on that project
	- `roles/resourcemanager.organizationAdmin`
	- `roles/logging.configWriter`
* **Project Level Integrations**
	- `roles/owner` - For Project level integrations it is recommended to use the Project being integrated to store all of the required resources. The user account used to run Google Cloud Shell must have 'OWNER' permissions on that project. 

## Integrate Google Cloud with Lacework at an Organzational level
The following section covers integrating Google Cloud and Lacework for analysis of Cloud Audit Logs and configuration assessment at an Organizational level. Organization level integrations cover all of the existing projects in the organization, and will automatically add any new projects added after the initial integration.

### Create a GCP Project using the GCP Console
Before you can execute Terraform you will need to create a GCP Project to provision the required resources for the integration between Google Cloud and Lacework.

![Create GCP Project](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_project_create_1024px.gif)

1. Log in to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select the Project drop-down and click **NEW PROJECT**
3. Give the project a **Project Name**, select a **Billing Account**, select the **Organization** you are integrating
3. Click **CREATE** to create the new project

#### Configure Project Owner permissions to user account
Now that a project has been created, you will need to configure `roles/owner` permissions to your user account for that project.

1. Log in to the [Google Cloud Console](https://console.cloud.google.com/)
2. Select the Project created for Lacework Resources in the previous step
3. Click on the **Navigation Menu** and select **IAM & Admin** -> **IAM**
4. Filter the list and find the user account that will be used to run Google Cloud Shell
5. Click **Edit Member** and then apply `role/owner`
6. Click **SAVE**

### Launch Google Cloud Shell within Google Console
To open the Google Cloud Shell, click on the Cloud Shell icon in the header bar of the Google Console, and it will launch the Cloud Shell in a pane at the bottom of the browser.

![Open Google Cloud Shell](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/google-cloud-shell-open.png)

### Install the Lacework CLI in Google Cloud Shell

The Terraform Provider for Lacework leverages the configuration from the Lacework CLI to authenticate with Lacework's API and configure accounts. The following `shell_startup.sh` script installs the Lacework CLI in Google Cloud Shell.

```
user@cloudshell:~ $ curl https://raw.githubusercontent.com/lacework/terraform-provisioning/master/gcp/shell_startup.sh | bash
```

When the script completes you need to type `exit` followed by enter to exit your shell. Once the shell has exited you can open the Cloud Shell again and the Lacework CLI will be ready for use!

#### Configure the Lacework CLI

Proceed to configure the Lacework CLI by using the command `lacework configure`. You will need three things:
* `account`: Account subdomain of URL (i.e. `<ACCOUNT>.lacework.net`)
* `api_key`: API Access Key
* `api_secret`: API Access Secret

>To create a set of API keys, log in to your Lacework account via WebUI and navigate to Settings > API Keys and
>click + Create New. Enter a name for the key and an optional description, then click Save. To get the secret key,
>download the generated API key file.

The Google Cloud Shell allows you to drag-and-drop the generated `KEY.json` to upload it automatically.

![Download-Drag-and-Drop Lacework API key](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/google-cloud-shell-drag-drop-api-key.gif)

Finally, run the command:
```
user@cloudshell:~ $ lacework configure -j CUSTOMER_EED10DA9136E9F763477FF5933464DD0C3DADF2CDDEF715.json
▸ Account: customerdemo
▸ Access Key ID: CUSTOMER_EED10DA9136E9F763477FF5933464DD0C3DADF2CDDEF715
▸ Secret Access Key: (*****************************26a0)

You are all set!
```

For more information about the Lacework CLI, see https://github.com/lacework/go-sdk/wiki/CLI-Documentation.

## Enable Google Compliance and Audit Log Integrations
Cloud Shell also has a built-in file editor that will give you a more graphically appealing experience for
editing files, to open the editor click the button "🖊️ **Open Editor**" and create a file named `main.tf`.

**NOTE:** You can also use the old school `vi` editor if you prefer to do so.
```
user@cloudshell:~ $ vi main.tf
```

Inside this file add the following code snippet that will configure both, Google Compliance and Audit Log
Integrations. The code leverages our Terraform modules to create resources in you Google Console as well as
connecting such resources to you Lacework account. To customize these modules look at the [following input
parameters](https://github.com/lacework/terraform-provisioning/tree/master/gcp#inputs).


### For Organization Level Integration
```hcl
provider "google" {}

provider "lacework" {}

module "gcp_organization_config" {
  source  = "lacework/config/gcp"
  version = "0.1.0"

  org_integration = true
  organization_id = "my-organization-id"
}

module "gcp_organization_audit_log" {
  source  = "lacework/audit-log/gcp"
  version = "0.1.0"

  bucket_force_destroy         = true
  org_integration              = true
  use_existing_service_account = true
  service_account_name         = module.gcp_organization_config.service_account_name
  service_account_private_key  = module.gcp_organization_config.service_account_private_key
  organization_id              = "my-organization-id"
}
```

__NOTE: Update 'my-organization-id' with your GCP Organization ID. You can use the command `gcloud organizations list` to look up your id.__

## Integrate Google Cloud with Lacework at a Project level
The following section covers integrating Google Cloud and Lacework for analysis of Cloud Audit Logs and configuration assessment at a Project level. 

In this method Terraform provisions all of the required resources in the project being integrated into Lacework.

### For Project Level Integration
```hcl
provider "google" {}

provider "lacework" {}

module "gcp_project_config" {
  source  = "lacework/config/gcp"
  version = "0.1.0"
}

module "gcp_project_audit_log" {
  source  = "lacework/audit-log/gcp"
  version = "0.1.0"
  
  bucket_force_destroy         = true
  use_existing_service_account = true
  service_account_name         = module.gcp_project_config.service_account_name
  service_account_private_key  = module.gcp_project_config service_account_private_key
}
```

__NOTE: If you choose the editor, don't forget to save the file.__

### Run the Automation. Run Terraform!

Run the command `terraform init` to download the necessary plugins and modules required to run this automation.
```
afiune@cloudshell:~ $ terraform init
```

Then, run `terraform apply`, this command will create a "plan" of the resources that will be created and stop
for you to type `yes` to proceed.
```
afiune@cloudshell:~ $ terraform apply
```

![Hit Yes](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/google-cloud-shell-terraform-apply.png)

**Hit yes!**

### Validate The Configuration

Once Terraform finishes applying changes, you can use the Lacework CLI or the UI to confirm the integration is working. 

For the CLI open a Terminal and run `lacework integrations list` (you should see the two `GCP_CFG` and `GCP_AT_SEQ` Integrations listed)

To validate the integration via the UI, Log in to your account and go to **Settings** -> **Integrations** -> **Cloud Accounts`
