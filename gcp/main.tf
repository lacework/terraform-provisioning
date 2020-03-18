provider "google" {
  credentials = file(var.credentials_file)

  project = var.project_id
  region = var.region
  zone = var.zone
}

data "google_project" "project" {
}

resource "google_service_account" "service_account" {
  account_id = "${var.prefix}-lacework-cfg-sa"
  display_name = "${var.prefix}-lacework-cfg-sa"
}

resource "google_project_iam_member" "project_viewer_binding" {
  count = var.org_integration ? 0 : 1

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/viewer"
  project = var.project_id
}

resource "google_project_iam_member" "project_security_reviewer_binding" {
  count = var.org_integration ? 0 : 1

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/iam.securityReviewer"
  project = var.project_id
}

resource "google_organization_iam_member" "organization_viewer_binding" {
  count = var.org_integration ? 1 : 0

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/viewer"
  org_id = var.organization_id
}

resource "google_organization_iam_member" "organization_security_reviewer_binding" {
  count = var.org_integration ? 1 : 0

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/iam.securityReviewer"
  org_id = var.organization_id
}

resource "google_organization_iam_member" "organization_resource_viewer_binding" {
  count = var.org_integration ? 1 : 0

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/resourcemanager.organizationViewer"
  org_id = var.organization_id
}

resource "google_service_account_key" "service-account-key-lacework" {
  service_account_id = google_service_account.service_account.name
}

resource "google_storage_bucket" "lacework_bucket" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  name = "${var.prefix}-${var.project_id}-lacework-bucket"
  force_destroy = var.force_destroy_bucket
}

resource "google_storage_bucket_iam_member" "bucket_object_viewer" {
  bucket = var.existing_bucket_name != "" && var.audit_log ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name
  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_binding" "legacy_bucket_owner" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  bucket = google_storage_bucket.lacework_bucket[count.index].name
  role = "roles/storage.legacyBucketOwner"
  members = ["projectEditor:${var.project_id}", "projectOwner:${var.project_id}"]
}

resource "google_storage_bucket_iam_binding" "legacy_bucket_reader" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  bucket = google_storage_bucket.lacework_bucket[count.index].name
  role = "roles/storage.legacyBucketReader"
  members = ["projectViewer:${var.project_id}"]
}

resource "google_pubsub_topic" "lacework_topic" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  name = "${var.prefix}-${var.project_id}-lacework-topic"
}

resource "google_pubsub_topic_iam_member" "topic_publisher" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  member = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
  role = "roles/pubsub.publisher"
  topic = google_pubsub_topic.lacework_topic[count.index].name
}

resource "google_pubsub_subscription" "lacework_subscription" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  name = "${var.prefix}-${var.project_id}-lacework-subscription"
  topic = google_pubsub_topic.lacework_topic[count.index].name
  ack_deadline_seconds = 300
  message_retention_duration = "432000s"
}

resource "google_pubsub_subscription_iam_member" "pubsub_subscriber" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  member = "serviceAccount:${google_service_account.service_account.email}"
  role = "roles/pubsub.subscriber"
  subscription = google_pubsub_subscription.lacework_subscription[count.index].name
}

resource "google_storage_notification" "lacework_notification" {
  count = var.existing_bucket_name != "" && var.audit_log ? 0 : 1

  bucket = google_storage_bucket.lacework_bucket[count.index].name
  payload_format = "JSON_API_V1"
  topic = google_pubsub_topic.lacework_topic[count.index].name
  event_types = ["OBJECT_FINALIZE"]

  depends_on = [google_pubsub_topic_iam_member.topic_publisher, google_storage_bucket_iam_binding.legacy_bucket_owner, google_storage_bucket_iam_binding.legacy_bucket_reader, google_storage_bucket_iam_member.bucket_object_viewer, google_storage_bucket_iam_member.project_sink_writer, google_storage_bucket_iam_member.organization_sink_writer]
}

resource "google_logging_project_sink" "lacework_project_sink" {
  count = var.org_integration && var.audit_log ? 0 : 1

  destination = "storage.googleapis.com/${var.existing_bucket_name != "" ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name}"
  name = "${var.prefix}-${var.project_id}-lacework-sink"
  unique_writer_identity = true
  filter = "protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog AND NOT protoPayload.methodName:'storage.objects'"
}

resource "google_storage_bucket_iam_member" "project_sink_writer" {
  count = var.org_integration && var.audit_log ? 0 : 1

  bucket = var.existing_bucket_name != "" ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name
  role = "roles/storage.objectCreator"
  member = google_logging_project_sink.lacework_project_sink[count.index].writer_identity
}

resource "google_logging_organization_sink" "lacework_organization_sink" {
  count = var.org_integration && var.audit_log ? 1 : 0

  destination = "storage.googleapis.com/${var.existing_bucket_name != "" ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name}"
  name = "${var.prefix}-${var.organization_id}-lacework-sink"
  org_id = var.organization_id
  include_children = true
  filter = "protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog AND NOT protoPayload.methodName:'storage.objects'"
}

resource "google_storage_bucket_iam_member" "organization_sink_writer" {
  count = var.org_integration && var.audit_log ? 1 : 0

  bucket = var.existing_bucket_name != "" ? var.existing_bucket_name : google_storage_bucket.lacework_bucket[0].name
  role = "roles/storage.objectCreator"
  member = google_logging_organization_sink.lacework_organization_sink[count.index].writer_identity
}
