output "client_id" {
  value = azuread_application.default.application_id
}

output "client_secret" {
  value = azuread_application_password.client_secret.value
}

output "tenant_id" {
  value = data.azurerm_subscription.primary.tenant_id
}

output "queue_url" {
  value = "https://${azurerm_storage_account.default.name}.queue.core.windows.net/${azurerm_storage_queue.default.name}"
}
