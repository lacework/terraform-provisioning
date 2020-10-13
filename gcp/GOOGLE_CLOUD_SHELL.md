# Google Cloud Shell
The Google Cloud Shell is an embedded terminal/command-line interface that can be used within the Google
Console. This shell is fully authenticated and comes with tools like the [Google Cloud SDK](https://cloud.google.com/sdk/gcloud/),
`gcloud`command-line tool and Terraform pre-installed to manage and automate your projects and resources in your
environment.

These instructions will show you how to get up-and-running with Lacework, Terraform and the Google Cloud Shell.
The only requirement we need is that your [Google Account](https://cloud.google.com/iam/docs/service-accounts) has
the following permissions:

### For Organization Level Integration
- Logs Configuration Writer
- Organziation Admin
- Project Owner

### For Project Level Integration
- Project Owner

## Open Google Cloud Shell within Google Console
To open the Google Cloud Shell, you simply click on the Cloud Shell icon in the header bar of the Google Console,
and it will open the Cloud Shell in a pane at the bottom of the browser.

![Open Google Cloud Shell](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/google-cloud-shell-open.png)

## Prepare your Cloud Shell

We need to run the `shell_startup.sh` script to install all the neccessary tools and configure some environment
variables required by Terraform.

```
afiune@cloudshell:~ $ curl https://raw.githubusercontent.com/lacework/terraform-provisioning/master/gcp/shell_startup.sh | bash
```

When the script completes you need to type `exit` followed by enter to exit your shell. Once the shell has exited you can open 
the Cloud Shell again and the Lacework CLI will be ready for use!

## Configure the Lacework CLI

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
afiune@cloudshell:~ $ lacework configure -j CUSTOMER_EED10DA9136E9F763477FF5933464DD0C3DADF2CDDEF715.json
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
afiune@cloudshell:~ $ vi main.tf
```

Inside this file add the following code snippet that will configure both, Google Compliance and Audit Log
Integrations. The code leverages our Terraform modules to create resources in you Google Console as well as
connecting such resources to you Lacework account. To customize these modules look at the [following input
parameters](https://github.com/lacework/terraform-provisioning/tree/master/gcp#inputs).

**IMPORTANT:** We use the `master` branch in source just as an example. In your code, **do NOT pin to master**
because there may be breaking changes between releases. Instead we recommend to pin to the release tag (e.g.
`?ref=tags/v0.1.0`) of one of our [latest releases](https://github.com/lacework/terraform-provisioning/releases).

### For Organization Level Integration
```hcl
provider "google" {}

provider "lacework" {}

module "gcp_organization_config" {
	source          = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/config?ref=master"
	org_integration = true
	organization_id = "my-organization-id"
}

module "gcp_organization_audit_log" {
	source                       = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/audit_log?ref=master"
	bucket_force_destroy         = true
	org_integration              = true
	use_existing_service_account = true
	service_account_name         = module.gcp_organization_config.service_account_name
	service_account_private_key  = module.gcp_organization_config.service_account_private_key
	organization_id              = "my-organization-id"
}
```

__NOTE: Update 'my-organization-id' with your GCP Organization ID. You can use the command `gcloud organizations list` to look up your id.__

### For Project Level Integration
```hcl
provider "google" {}

provider "lacework" {}

module "gcp_project_config" {
	source = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/config?ref=master"
}

module "gcp_project_audit_log" {
	source                       = "git::https://github.com/lacework/terraform-provisioning.git//gcp/modules/audit_log?ref=master"
	bucket_force_destroy         = true
	use_existing_service_account = true
	service_account_name         = module.gcp_project_config.service_account_name
	service_account_private_key  = module.gcp_project_config.service_account_private_key
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

### Verify Lacework Integrations

To verify if the two integrations have been configured successfully, run the command:
```
afiune@cloudshell:~ $ lacework integrations list
```
