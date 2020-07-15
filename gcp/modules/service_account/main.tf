locals {
	project_roles = var.org_integration ? [] : [
		"roles/viewer",
		"roles/iam.securityReviewer"
	]
	organization_roles = var.org_integration ? [
		"roles/viewer",
		"roles/iam.securityReviewer",
		"roles/resourcemanager.organizationViewer"
	] : [] 
	project_id = data.google_project.selected.project_id
	service_account_name   = var.create ? google_service_account.lacework[0].display_name  : data.google_service_account.selected.display_name
	service_account_email  = var.create ? google_service_account.lacework[0].email : data.google_service_account.selected.email
}

data "google_project" "selected" {
	project_id = var.project_id
}

resource "google_project_service" "required_apis" {
	for_each = var.required_apis
	project  = local.project_id
	service  = each.value

	disable_on_destroy = false
}

resource "google_service_account" "lacework" {
	count        = var.create ? 1 : 0
	account_id   = var.service_account_name
	display_name = var.service_account_name
	depends_on   = [google_project_service.required_apis]
}

// Roles for a PROJECT level integration
resource "google_project_iam_member" "for_lacework_service_account" {
	for_each = toset(local.project_roles)
	project  = local.project_id
	role     = each.value
	member   = "serviceAccount:${local.service_account_email}"
}

// Roles for an ORGANIZATION level integration
resource "google_organization_iam_member" "for_lacework_service_account" {
	for_each = toset(local.organization_roles)
	org_id   = var.organization_id
	role     = each.value
	member   = "serviceAccount:${local.service_account_email}"
}

resource "google_service_account_key" "lacework" {
	service_account_id = local.service_account_name
	depends_on         = [
		google_organization_iam_member.for_lacework_service_account,
		google_project_iam_member.for_lacework_service_account
	]
}

# wait for 5 seconds for the role to be created before trying to query it
resource "time_sleep" "wait_5_seconds" {
	create_duration = "5s"
	depends_on      = [google_service_account.lacework]
}

data "google_service_account" "selected" {
	account_id = var.service_account_name
	depends_on = [time_sleep.wait_5_seconds]
}
