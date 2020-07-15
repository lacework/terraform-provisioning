output "service_account_name" {
	value       = module.lacework_svc_account.name
	description = "The Service Account name"
}

output "bucket_name" {
	value       = local.bucket_name
	description = "The storage bucket name"
}

output "pubsub_topic_name" {
	value       = google_pubsub_topic.lacework_topic.name
	description = "The PubSub topic name"
}
