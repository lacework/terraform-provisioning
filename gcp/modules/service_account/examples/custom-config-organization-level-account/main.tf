provider "google" {
	credentials = file("account.json")
	project     = "my-project"
}

module "lacework_svc_account" {
	source               = "../../"
	org_integration      = true
	organization_id      = "my-organization-id"
	project_id           = "a-different-project-id"
	service_account_name = "lacework-custom-svc-account"
}
