# Integrate Google Cloud Platform with Lacework using Terraform
Lacework integrates with Google Cloud Platform to analyze Cloud Audit Logs and to assess cloud resource configurations at an Organization level or at a per Project level. 

Organization level integrations cover all of the existing projects in the organization, and will automatically add any new projects added after the initial integration. 

A Project level integration only covers specific projects and any new projects will need to be added as required.

In order to integrate at an Organization or Project level Lacework requires the following resources be provisioned in Google Cloud:

* **Google Cloud Project** - A project to contain the required cloud resources with billing enabled. When integrating at an Organization level, it is recommended that a project is created specifically for Lacework resources. When integrating at a project level all required resources for Lacework may be provisioned within the project being integrated.
* **Google Storage Bucket** - A storage bucket for Stack Driver logs
* **Google Pub/Sub Topic** - For Cloud Audit Logs events
* **Google Logging Sink** - To export Cloud Audit Logs to Cloud Storage Bucket
* **Service Account for Lacework** - A service account will be created to provide Lacework read-only access to Google Cloud Platform with the following roles:
	* Organziation Level Integration
		- `roles/resourcemanager.organizationViewer`
		- `roles/iam.securityReviewer`
		- `roles/viewer`
	* Project Level Integration
		- `roles/viewer`
		- `roles/iam.securityReviewer`

## Running Lacework Terraform Modules for Google Cloud
There are two approaches running Lacework Terraform modules to integrate Google Cloud with Lacework:

### Google Cloud Shell
![Google Cloud Shell](https://techally-artifacts.s3-us-west-2.amazonaws.com/github-terraform-provisioning-imgs/google-cloud-shell-terraform-apply.png)

This approach uses [Google Cloud Shell](https://cloud.google.com/shell) to run Terraform, which is already installed by default in Cloud Shell. Google Cloud Shell inherits the permissions of the person logged in that launches Cloud Shell, which means Terraform will inherit those same permissions. 

This approach is suitable for one-off integrations where the user does not plan to continue to use Terraform to manage Lacework and Google Cloud, or store the state in source control.

For instructions on using Google Cloud Shell to run Lacework Terraform modules click [here](integrate_gcp_using_google_cloud_shell.md)

### Terraform installed on any supported host

![Terraform Code](https://techally-artifacts.s3-us-west-2.amazonaws.com/terraform-module-docs/gcp_org_terraform_init_1024px.gif)

In this approach, Terraform is installed, configured, and run from any supported system (Linux/macOS/Windows) and leverages a user account or a Google Cloud Service Account with required permissions to administer Google Cloud using Terraform. 

This approach is suitable for companies that store Terraform code in source control, and plan to continue to manage the state of the integration between Lacework and Google cloud going forward.

For instructions on how to run Lacework Terraform modules from any supported platform click [here](integrate_gcp_using_supported_system.md)
