output "subscription" {
  value = var.existing_bucket_name == "" && var.audit_log ? "projects/${var.project_id}/subscriptions/${google_pubsub_subscription.lacework_subscription[0].name}" : ""
  depends_on = [google_pubsub_subscription.lacework_subscription]
}

output "existing_subscription" {
  value = var.existing_bucket_name != "" ? "Use existing subscription associated with the existing bucket" : "Use subscription printed with output"
}
