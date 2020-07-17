provider "google" {
	credentials = file("account.json")
	project     = "my-project"
}

provider "lacework" {}

module "gcp_organization_level_audit_log" {
	source               = "../../"
	bucket_force_destroy = true
}
