locals {
  application_id       = var.use_existing_ad_application ? var.application_id : module.az_al_ad_application.application_id
  application_password = var.use_existing_ad_application ? var.application_password : module.az_al_ad_application.application_password
  service_principal_id = var.use_existing_ad_application ? var.service_principal_id : module.az_al_ad_application.service_principal_id
}

module "az_al_ad_application" {
  source                      = "../ad_application"
  create                      = var.use_existing_ad_application ? false : true
  application_name            = var.application_name
  application_identifier_uris = var.application_identifier_uris
  subscription_ids            = var.subscription_ids
  all_subscriptions           = var.all_subscriptions
  key_vault_ids               = var.key_vault_ids
  tenant_id                   = var.tenant_id
  password_length             = var.password_length
}

resource "azurerm_resource_group" "lacework" {
  name     = "${var.prefix}-group"
  location = var.location
}

# NOTE: storage name can only consist of lowercase letters and numbers,
# and must be between 3 and 24 characters long
resource "azurerm_storage_account" "lacework" {
  name                      = "${var.prefix}storage"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  location                  = var.location
  resource_group_name       = azurerm_resource_group.lacework.name
  #enable_blob_encryption    = true
}

resource "azurerm_storage_queue" "lacework" {
  name                 = "${var.prefix}-queue"
  storage_account_name = azurerm_storage_account.lacework.name
}

resource "azurerm_eventgrid_event_subscription" "lacework" {
  name  = "${var.prefix}-subscription"
  scope = azurerm_storage_account.lacework.id

  storage_queue_endpoint {
    queue_name         = azurerm_storage_queue.lacework.name
    storage_account_id = azurerm_storage_account.lacework.id
  }

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/insights-operational-logs/"
  }

  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
}

resource "azurerm_monitor_log_profile" "lacework" {
  name               = "${var.prefix}-log-profile"
  locations          = var.log_profile_locations
  storage_account_id = azurerm_storage_account.lacework.id

  categories = [
    "Action",
    "Delete",
    "Write",
  ]

  # TODO @afiune customize these settings
  retention_policy {
    enabled = true
    days    = 7
  }
}

# TODO @afiune maybe we could add a subscription_id variable
data "azurerm_subscription" "primary" {}
resource "azurerm_role_definition" "lacework" {
  name        = "${var.prefix}-role"
  description = "Used by Lacework to monitor Activity Logs"
  scope       = data.azurerm_subscription.primary.id

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

resource "azurerm_role_assignment" "lacework" {
  role_definition_id = azurerm_role_definition.lacework.id
  principal_id       = local.service_principal_id
  scope              = data.azurerm_subscription.primary.id
}

# wait for X seconds for the Azure resources to be created
resource "time_sleep" "wait_time" {
  create_duration = var.wait_time
  depends_on = [
    azurerm_eventgrid_event_subscription.lacework,
    azurerm_monitor_log_profile.lacework,
    azurerm_role_assignment.lacework,
    module.az_al_ad_application
  ]
}

resource "lacework_integration_azure_al" "default" {
  name      = var.lacework_integration_name
  tenant_id = module.az_al_ad_application.tenant_id
  queue_url = "https://${azurerm_storage_account.lacework.name}.queue.core.windows.net/${azurerm_storage_queue.lacework.name}"
  credentials {
    client_id     = local.application_id
    client_secret = local.application_password
  }
  depends_on = [time_sleep.wait_time]
}
