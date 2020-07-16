provider "google" {
	credentials = file("account.json")
	project     = "my-project"
}

provider "lacework" {}

module "gcp_organization_level_config" {
	source                       = "../../"
	use_existing_service_account = true
	service_account_name         = "my-service-account"
	service_account_private_key  = "(base64encode)"
	org_integration              = true
	organization_id              = "my-organization-id"
}
