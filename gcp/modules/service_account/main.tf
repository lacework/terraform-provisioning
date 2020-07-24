locals {
	default_project_roles = [
		"roles/viewer",
		"roles/iam.securityReviewer"
	]
	default_organization_roles = [
		"roles/viewer",
		"roles/iam.securityReviewer",
		"roles/resourcemanager.organizationViewer"
	]
	project_roles         = var.org_integration ? [] : (var.create ? local.default_project_roles : [])
	organization_roles    = var.create && var.org_integration ? local.default_organization_roles : [] 
	project_id            = data.google_project.selected.project_id
	service_account_name  = var.create ? (
		length(google_service_account.lacework) > 0 ? google_service_account.lacework[0].display_name :  ""
	) : data.google_service_account.selected[0].display_name
	service_account_email = var.create ? (
		length(google_service_account.lacework) > 0 ? google_service_account.lacework[0].email :  ""
	) : data.google_service_account.selected[0].email
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
	project      = local.project_id
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
	count              = var.create ? 1 : 0
	service_account_id = google_service_account.lacework[count.index].name
	depends_on         = [
		google_organization_iam_member.for_lacework_service_account,
		google_project_iam_member.for_lacework_service_account
	]
}

data "google_service_account" "selected" {
	count      = var.create ? 0 : 1
	account_id = var.service_account_name
}
