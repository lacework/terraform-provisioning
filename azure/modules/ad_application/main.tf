locals {
  tenant_id = length(var.tenant_id) > 0 ? var.tenant_id : data.azurerm_subscription.primary.tenant_id
  application_id = var.create ? (
    length(azuread_application.lacework) > 0 ? azuread_application.lacework[0].application_id : ""
  ) : ""
  application_password = var.create ? (
    length(azuread_application_password.client_secret) > 0 ? azuread_application_password.client_secret[0].value : ""
  ) : ""
  service_principal_id = var.create ? (
    length(azuread_service_principal.lacework) > 0 ? azuread_service_principal.lacework[0].object_id : ""
  ) : ""
}

data "azurerm_subscription" "primary" {}
resource "azuread_application" "lacework" {
  count           = var.create ? 1 : 0
  name            = var.application_name
  identifier_uris = var.application_identifier_uris

  // Microsoft Graph
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214"
      type = "Role"
    }
  }

  // AAD Graph API
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      id   = "5778995a-e1bf-45b8-affa-663a9f3f4d04"
      type = "Role"
    }
  }

  // Azure Storage
  required_resource_access {
    resource_app_id = "e406a681-f3d4-42a8-90b6-c2b029497af1"

    resource_access {
      id   = "03e0da56-190b-40ad-a80c-ea378c433f7f"
      type = "Scope"
    }
  }

  // Azure Key Vault
  required_resource_access {
    resource_app_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

    resource_access {
      id   = "f53da476-18e3-4152-8e01-aec403e6edc0"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "lacework" {
  count          = var.create ? 1 : 0
  application_id = local.application_id

  # ** WORKAROUND: @afiune today it is NOT possible to automate the process of granting admin
  #                consent to new Active Directory Applications, though it is possible to do
  #                it via the AzureCLI, this nice trick will try to automatically grant admin
  #                consent and, if it does not succeed, it will print out the URL that the user
  #                needs to follow do grant manual admin consent. Wihtout this permission we
  #                won't be able to create Azure Integration on the user's Lacework account.
  #
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${local.application_id} && echo SUCCESS!! || echo ERROR!!! Unable to grant admin consent, grant it manually by following the URL: https://login.microsoftonline.com/${local.tenant_id}/adminconsent?client_id=${local.application_id}"
  }
}

resource "azurerm_key_vault_access_policy" "default" {
  count        = var.create ? length(var.key_vault_ids) : 0
  key_vault_id = var.key_vault_ids[count.index]
  object_id    = local.service_principal_id
  tenant_id    = local.tenant_id

  key_permissions = [
    "List"
  ]
  secret_permissions = [
    "List"
  ]
}

data "azurerm_subscriptions" "available" {}
resource "azurerm_role_assignment" "grant_reader_role_to_subscriptions" {
  count = var.create ? length(data.azurerm_subscriptions.available.subscriptions) : 0
  scope = "/subscriptions/${data.azurerm_subscriptions.available.subscriptions[count.index].subscription_id}"

  principal_id         = local.service_principal_id
  role_definition_name = "Reader"
}

resource "random_password" "generator" {
  count  = var.create ? 1 : 0
  length = var.password_length
}

resource "azuread_application_password" "client_secret" {
  count                 = var.create ? 1 : 0
  application_object_id = azuread_application.lacework[count.index].object_id
  value                 = random_password.generator[count.index].result
  end_date              = "2299-12-31T01:02:03Z"
  depends_on            = [azuread_service_principal.lacework]
}
