// This template assumes the default configuration coming from the following
// environment variables 'GOOGLE_CREDENTIALS' and 'GOOGLE_PROJECT'
//
// Example of how to run this code:
//
// $ terraform init
// $ GOOGLE_CREDENTIALS=account.json GOOGLE_PROJECT=my-project terraform apply
provider "google" {}

module "lacework_svc_account" {
	source = "../../"
}
