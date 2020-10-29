# Integrate Google Cloud and Lacework using Terraform on any supported host
In this method, Terraform is installed, configured, and run from any supported system (Linux/macOS/Windows) and leverages a Service Account of choice to run Terraform. 

This method is geared towards companies that store Terraform code in source control, and plan to continue to manage the state of the integration between Lacework and Google cloud using Terraform. 

These instructions will show you how to get up-and-running with Lacework Terraform modules to integrate Google Cloud and Lacework at either an Organization Level or a per Project Level.

### Requirements
- Google Cloud Console Access
- Terraform - v.0.12.x, v.0.13.x
- Lacework Console Access

## Integrate Google Cloud with Lacework at an Organzational level
The following section covers integrating Google Cloud and Lacework for analysis of Cloud Audit Logs and configuration assessment at an Organizational level. Organization level integrations cover all of the existing projects in the organization, and will automatically add any new projects added after the initial integration.


### Create a GCP Project using the GCP Console
Before you can execute Terraform you will need to create a GCP Project to provision the required resources for the integration between Google Cloud and Lacework.
![Create GCP Project](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_project_create_1024px.gif)
1. Login to the Google Cloud Console
2. Select the Project drop-down and click **NEW PROJECT**
3. Give the project a **Project Name**, select a **Billing Account**, select the **Organization** you are integrating
3. Click **CREATE** to create the new project

### Create a Service Account for Terraform
In order to integrate GCP and Lacework at an Organizational level Terraform needs a service account with the following permissions:

- `roles/owner`
- `roles/resourcemanager.organizationAdmin`
- `roles/logging.configWriter`

If you already have an account configured with these permissions you can skip the next section

#### Creating a Service Account using the GCP Console
This section covers creating a Google Cloud Service Account with the required permissions to integrate Lacework at an Organization level.
![Service Account Project Owner](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_service_account_create_complete_1024px.gif)

1. Login to the Google Cloud Console
2. Select the Project created for Lacework Resources
3. Click on the **Navigation Menu** and select **IAM & Admin** -> **Service Accounts**
4. Click **CREATE SERVICE ACCOUNT**
5. Give the service account a name (i.e. terraform-provisioning) and optionally a description, and click **CREATE**
6. Under the section **"Grant this service account access to project"** give the service account **"Owner"** permissions to the project
7. Click **SAVE**

#### Add Service Account to Organization with required permissions
This section covers adding the service account as a member of the organization and configures the required organization permissions for Terraform to configure the organization.

1. Select the organization you are going to integrate with Lacework, select **IAM** from the Navigation Menu, and then click the **+ADD** button to add a member or role to the organization
2. Search for the service account then add permissions for **Organization Administrator** and **Logs Configuration Writer**
3. Click **SAVE**

![Service Account Org Permissions](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_service_account_org_permissions_1024px.gif)

#### Create Service Account Key
This section covers creating a service key and downloading to the local system as a `JSON` file

![Create Key](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_create_key_1024px.gif)

1. Login to the Google Cloud Console
2. Select the Project created for Lacework Resources
3. Click on the **Navigation Menu** and select **IAM & Admin** -> **Service Accounts**
4. Click on the Actions menu next to the service account
5. Click **Create Key**
6. Select JSON for the format of the key
7. Click **Create** to download the key locally

### Run Terraform to integrate GCP at Organization Level
This section covers executing Terraform. It is recommended you use a developer's code editor such as [VSCode](https://code.visualstudio.com/download), [Atom](https://atom.io/), or [Sublime](https://www.sublimetext.com/3). You will also need a terminal to run `terraform` commands such as `bash`, `zsh`, `powershell` or `cmd`
![Terraform Code](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_org_terraform_init_1024px.gif)
1. Open an EDITOR of choice and create a new file called `main.tf`
2. Copy/paste the following code into the `main.tf` and save the file
```hcl
provider "google" {
  credentials = file("account.json")
  project     = "my-project-id"
}

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

3. Update both the `credentials` and the `project` in the `provider "google"` to reference your credentials file downloaded in the previous section, and the Google Project ID
4. Open a terminal, change directory to the location where you have saved the `main.tf` and run the command `terraform init` to initialize the project
5. Run `terraform plan` to review the changes, and then run `terraform apply` when you are ready to apply the changes

Once Terraform completes you can validate the integration using the Lacework CLI with the command `lacework integration list`



## Integrate Google Cloud with Lacework at a Project level
The following section covers integrating Google Cloud and Lacework for analysis of Cloud Audit Logs and ressource configuration assessment at a Project level. 

In this method Terraform provisions all of the required resources in the the project being integrated into Lacework.

### Create a Service Account for Terraform
In order to integrate GCP and Lacework at a Project level Terraform needs an service account with the following permissions in the Project being integrated:

- `roles/owner`

If you already have an account configured with these permissions you can skip the next section

#### Creating a Service Account using the GCP Console
This section convers creating a Google Cloud Service Account with the required permissions to integrate Lacework at a Project level.
![Service Account Project Owner](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_service_account_create_complete_1024px.gif)

1. Login to the Google Cloud Console
2. Select the Project being integrated with Lacework
3. Click on the **Navigation Menu** and select **IAM & Admin** -> **Service Accounts**
4. Click **CREATE SERVICE ACCOUNT**
5. Give the service account a name (i.e. terraform-provisioning) and optionally a description, and click **CREATE**
6. Under the section **"Grant this service account access to project"** give the service account **"Owner"** permissions to the project
7. Click **SAVE**

#### Create Service Account Key
This section covers creating a service key and downloading to the local system as a `JSON` file

![Create Key](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_create_key_1024px.gif)

1. Login to the Google Cloud Console
2. Select the Project being integrated with Lacework
3. Click on the **Navigation Menu** and select **IAM & Admin** -> **Service Accounts**
4. Locate the Service Account created for Terraform and click on the Actions menu next to the service account
5. Click **Create Key**
6. Select JSON for the format of the key
7. Click **Create** to download the key locally

### Run Terraform to integrate GCP at Project Level
This section covers executing Terraform. It is recommended you use a developer's code editor such as [VSCode](https://code.visualstudio.com/download), [Atom](https://atom.io/), or [Sublime](https://www.sublimetext.com/3). You will also need a terminal to run `terraform` commands such as `bash`, `zsh`, `powershell` or `cmd`
![Terraform Code](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_project_terraform_init_1024px.gif)
1. Open an EDITOR of choice and create a new file called `main.tf`
2. Copy/paste the following code into the `main.tf` and save the file
```hcl
provider "google" {
  credentials = file("account.json")
  project     = "my-project-id"
}

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

3. Update both the `credentials` and the `project` in the `provider "google"` to reference your credentials file downloaded in the previous section, and the Google Project ID
4. Open a terminal, change directory to the location where you have saved the `main.tf` and run the command `terraform init` to initialize the project
5. Run `terraform plan` to review the changes, and then run `terraform apply` when you are ready to apply the changes

Once Terraform completes you can validate the integration using the Lacework CLI with the command `lacework integration list`
