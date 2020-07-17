provider "google" {
	credentials = file("account.json")
	project     = "my-project"
}

provider "lacework" {}

module "gcp_organization_level_config" {
	source          = "../../"
	org_integration = true
	organization_id = "my-organization-id"
}
