locals {
	resource_level = var.org_integration ? "ORGANIZATION" : "PROJECT"
	resource_id    = var.org_integration ? var.organization_id : module.lacework_svc_account.project_id
	bucket_name    = length(var.existing_bucket_name) > 0 ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name
	project_id     = data.google_project.selected.project_id
	project_number = data.google_project.selected.number
	logging_sink_writer_identity = var.org_integration ? (
		google_logging_organization_sink.lacework_organization_sink[0].writer_identity
	) : (
		google_logging_project_sink.lacework_project_sink[0].writer_identity
	)
	service_account_name  = var.use_existing_service_account ? var.service_account_name : (
		length(var.service_account_name) > 0 ? var.service_account_name : "${var.prefix}-lacework-svc-account"
	)
}

data "google_project" "selected" {
	project_id = var.project_id
}

module "lacework_svc_account" {
	source               = "../service_account"
	create               = var.use_existing_service_account ? false : true
	service_account_name = local.service_account_name
	org_integration      = var.org_integration
	organization_id      = var.organization_id
	project_id           = local.project_id
}

resource "google_storage_bucket" "lacework_bucket" {
	count         = length(var.existing_bucket_name) > 0 ? 0 : 1
	project       = local.project_id
	name          = "${var.prefix}-lacework-bucket"
	force_destroy = var.bucket_force_destroy
}

resource "google_storage_bucket_iam_binding" "legacy_bucket_owner" {
	bucket  = local.bucket_name
	role    = "roles/storage.legacyBucketOwner"
	members = ["projectEditor:${local.project_id}", "projectOwner:${local.project_id}"]
}

resource "google_storage_bucket_iam_binding" "legacy_bucket_reader" {
	bucket  = local.bucket_name
	role    = "roles/storage.legacyBucketReader"
	members = ["projectViewer:${local.project_id}"]
}

resource "google_pubsub_topic" "lacework_topic" {
	name    = "${var.prefix}-lacework-topic"
	project = local.project_id
}

resource "google_pubsub_topic_iam_member" "topic_publisher" {
	member = "serviceAccount:service-${local.project_number}@gs-project-accounts.iam.gserviceaccount.com"
	role   = "roles/pubsub.publisher"
	topic  = google_pubsub_topic.lacework_topic.name
}

resource "google_pubsub_subscription" "lacework_subscription" {
	name                       = "${var.prefix}-${local.project_id}-lacework-subscription"
	topic                      = google_pubsub_topic.lacework_topic.name
	ack_deadline_seconds       = 300
	message_retention_duration = "432000s"
}

resource "google_logging_project_sink" "lacework_project_sink" {
	count                  = var.org_integration ? 0 : 1
	project                = local.project_id
	name                   = "${var.prefix}-lacework-sink"
	destination            = "storage.googleapis.com/${local.bucket_name}"
	unique_writer_identity = true

	filter = "protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog AND NOT protoPayload.methodName:'storage.objects'"
}

resource "google_logging_organization_sink" "lacework_organization_sink" {
	count            = var.org_integration ? 1 : 0
	name             = "${var.prefix}-${var.organization_id}-lacework-sink"
	org_id           = var.organization_id
	destination      = "storage.googleapis.com/${local.bucket_name}"
	include_children = true

	filter = "protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog AND NOT protoPayload.methodName:'storage.objects'"
}

resource "google_pubsub_subscription_iam_member" "lacework" {
	role         = "roles/pubsub.subscriber"
	member       = "serviceAccount:${module.lacework_svc_account.email}"
	subscription = google_pubsub_subscription.lacework_subscription.name
}

resource "google_storage_bucket_iam_member" "object_viewer" {
	role   = "roles/storage.objectViewer"
	bucket = local.bucket_name
	member = "serviceAccount:${module.lacework_svc_account.email}"
}

resource "google_storage_bucket_iam_member" "sink_writer" {
	role   = "roles/storage.objectCreator"
	bucket = local.bucket_name
	member = local.logging_sink_writer_identity
}

resource "google_storage_notification" "lacework_notification" {
	bucket         = local.bucket_name
	payload_format = "JSON_API_V1"
	topic          = google_pubsub_topic.lacework_topic.name
	event_types    = ["OBJECT_FINALIZE"]

	depends_on = [
		google_pubsub_topic_iam_member.topic_publisher,
		google_storage_bucket_iam_binding.legacy_bucket_owner, 
		google_storage_bucket_iam_binding.legacy_bucket_reader, 
		google_storage_bucket_iam_member.object_viewer, 
		google_storage_bucket_iam_member.sink_writer
	]
}

data "null_data_source" "lacework_service_account_private_key" {
	inputs = {
		json = base64decode(module.lacework_svc_account.private_key)
	}
}

# wait for 5 seconds for things to settle down in the GCP side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_5_seconds" {
	create_duration = "5s"
	depends_on      = [
		data.null_data_source.lacework_service_account_private_key,
		google_storage_notification.lacework_notification,
		google_pubsub_subscription_iam_member.lacework
	]
}

resource "lacework_integration_gcp_at" "default" {
	name           = var.lacework_integration_name
	resource_id    = local.resource_id
	resource_level = local.resource_level
	subscription   = google_pubsub_subscription.lacework_subscription.path
	credentials {
		client_id      = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).client_id
		private_key_id = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).private_key_id
		client_email   = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).client_email
		private_key    = jsondecode(data.null_data_source.lacework_service_account_private_key.outputs["json"]).private_key
	}
	depends_on = [time_sleep.wait_5_seconds]
}
