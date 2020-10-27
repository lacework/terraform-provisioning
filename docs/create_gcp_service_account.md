# Create Google Cloud Service Account for use with Terraform
The following document explains how to create a Google Cloud Service Account for use with Lacework Terraform modules to integrate Lacework and Google Cloud. 

In order to run Terraform to integrate Google Cloud at an Organziation Level or at at per Project Level system executing Terraform must have a service account with the following roles assigned:

* **Organzaztion Level Integration**
  - `roles/owner`
  - `roles/resourcemanager.organizationAdmin`
  - `roles/logging.configWriter`
* **Project Level Integration**
  - `roles/owner`

## Create Service Account with Google Cloud Console
1. Login to [Google Cloud Console](https://console.cloud.google.com)
2. Click on the **Navigation menu** and choose **Iam & Admin** -> **Service Accounts**

![alt text](img/gcp/gcp-iam-service-account.gif "Create Service Account")
3. Click "**CREATE SERVICE ACCOUNT**"
4. Give the service account a name, ID, and description:

    Name: terraform-provisioning
    ID: terraform-provisioning
    Description: A service account used for Terraform to integrate Google Cloud with Lacework
5. Click "**Create**"
laceor