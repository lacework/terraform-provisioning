provider "azuread" {
  version = "=0.7.0"
}

provider "azurerm" {
  version = "=1.44.0"
}

provider "random" {
  version = "=2.2"
}

locals {
  resource_group = var.resource_group == null ? "${var.prefix}lwresourcegroup" : var.resource_group
  storage = var.storage == null ? "${var.prefix}lwstorage" : var.storage
  storage_queue = var.storage_queue == null ? "${var.prefix}lwstoragequeue" : var.storage_queue
  event_subscription = var.event_subscription == null ? "${var.prefix}lweventsub" : var.event_subscription
  log_profile = var.log_profile == null ? "${var.prefix}lwlogprofile" : var.log_profile
}

resource "azuread_application" "default" {
  name = var.app_name
  identifier_uris = var.identifier_uris

  // Microsoft Graph
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    resource_access {
      id = "df021288-bdef-4463-88db-98f22de89214"
      type = "Role"
    }
  }

  // AAD Graph API
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      id = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
      type = "Role"
    }
  }

  // Azure Storage
  required_resource_access {
    resource_app_id = "e406a681-f3d4-42a8-90b6-c2b029497af1"

    resource_access {
      id = "03e0da56-190b-40ad-a80c-ea378c433f7f"
      type = "Scope"
    }
  }

  // Azure Key Vault
  required_resource_access {
    resource_app_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

    resource_access {
      id = "f53da476-18e3-4152-8e01-aec403e6edc0"
      type = "Scope"
    }
  }
}

resource "random_uuid" "generator" {}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.default.id
  value = random_uuid.generator.result
  end_date = "2299-12-31T01:02:03Z"
}

resource "azuread_service_principal" "default" {
  application_id = azuread_application.default.application_id
}

data "azurerm_subscriptions" "available" {}

resource "azurerm_role_assignment" "ex" {
  count = length(data.azurerm_subscriptions.available.subscriptions)

  scope = "/subscriptions/${data.azurerm_subscriptions.available.subscriptions[count.index].subscription_id}"
  role_definition_name = "Reader"
  principal_id = azuread_service_principal.default.id
}

data "azurerm_subscription" "primary" {}

resource "azurerm_key_vault_access_policy" "default" {
  count = length(var.key_vault_ids)

  key_vault_id = var.key_vault_ids[count.index]
  object_id = azuread_service_principal.default.id
  tenant_id = data.azurerm_subscription.primary.tenant_id

  key_permissions = [
    "List"
  ]
  secret_permissions = [
    "List"
  ]
}

// ------------------------------------------------------------------------------

resource "azurerm_resource_group" "default" {
  name = local.resource_group
  location = var.location
}

resource "azurerm_storage_account" "default" {
  name = local.storage
  account_kind = "StorageV2"
  account_replication_type = "LRS"
  account_tier = "Standard"
  enable_blob_encryption = true
  enable_https_traffic_only = true
  location = var.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_storage_queue" "default" {
  name = local.storage_queue
  storage_account_name = azurerm_storage_account.default.name
}

resource "azurerm_eventgrid_event_subscription" "default" {
  name = local.event_subscription
  scope = azurerm_storage_account.default.id

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.default.id
    queue_name = azurerm_storage_queue.default.name
  }

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/insights-operational-logs/"
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
}

resource "azurerm_monitor_log_profile" "default" {
  name = local.log_profile

  categories = [
    "Action",
    "Delete",
    "Write",
  ]

  locations = var.log_profile_locations

  storage_account_id = azurerm_storage_account.default.id

  retention_policy {
    enabled = true
    days = 7
  }
}

resource "azurerm_role_definition" "default" {
  name = "${var.prefix}lwrole"
  description = "Monitors Activity Log"

  scope = data.azurerm_subscription.primary.id
  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/queueServices/queues/read",
      "Microsoft.EventGrid/eventSubscriptions/read",
      "Microsoft.Storage/storageAccounts/listkeys/action"
    ]

    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/queueServices/queues/messages/read",
      "Microsoft.Storage/storageAccounts/queueServices/queues/messages/delete"
    ]
  }
}

resource "azurerm_role_assignment" "default" {
  role_definition_id = azurerm_role_definition.default.id
  principal_id = azuread_service_principal.default.id
  scope = data.azurerm_subscription.primary.id
}

provider "lacework" {
  account    = var.lacework_account
  api_key    = var.lacework_api_key
  api_secret = var.lacework_api_secret
}

resource "lacework_integration_azure_cfg" "default" {
  name      = var.lacework_integration_config_name
  tenant_id = data.azurerm_subscription.primary.tenant_id
  credentials {
    client_id     = azuread_application.default.application_id
    client_secret = azuread_application_password.client_secret.value
  }
  depends_on = [ azurerm_eventgrid_event_subscription.default ]
}

resource "lacework_integration_azure_al" "default" {
  name      = var.lacework_integration_activitylog_name
  tenant_id = data.azurerm_subscription.primary.tenant_id
  queue_url = "https://${azurerm_storage_account.default.name}.queue.core.windows.net/${azurerm_storage_queue.default.name}"
  credentials {
    client_id     = azuread_application.default.application_id
    client_secret = azuread_application_password.client_secret.value
  }
  depends_on = [
    azurerm_eventgrid_event_subscription.default,
    lacework_integration_azure_cfg.default
  ]
}
