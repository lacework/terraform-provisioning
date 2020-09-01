provider "google" {}

provider "lacework" {}

module "gcp_project_level_config" {
	source = "../../"
}
