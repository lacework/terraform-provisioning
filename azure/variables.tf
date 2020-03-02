variable "app_name" {
  type = string
  description = "Name of the Azure Active Directory App."
  default = "LaceworkSAAudit"
}

variable "identifier_uris" {
  type = list(string)
  description = "URI's for app"
  default = [
    "https://securityaudit.lacework.net"
  ]
}

variable "key_vault_ids" {
  type = list(string)
  description = "Key Vault Ids"
  default = []
}

variable "prefix" {
  type = string
  description = "The Prefix used for all resources in this example"
  default = "dev"
}

variable "location" {
  type = string
  description = "The Azure Region in which all resources in this example should be created."
  default = "West US 2"
}

variable "resource_group" {
  type = string
  description = "Resource group name to use."
  default = null
}

variable "storage" {
  type = string
  description = "Storage name to use for Activity Log."
  default = null
}

variable "storage_queue" {
  type = string
  description = "Storage queue name to use for Activity Log."
  default = null
}

variable "event_subscription" {
  type = string
  description = "Event subscription name to use for Activity Log."
  default = null
}

variable "log_profile" {
  type = string
  description = "Log profile name for Activity Log."
  default = null
}

variable "log_profile_locations" {
  type = list(string)
  description = "Locations for log profile"
  default = [
    "eastasia",
    "southeastasia",
    "centralus",
    "eastus",
    "eastus2",
    "westus",
    "northcentralus",
    "southcentralus",
    "northeurope",
    "westeurope",
    "japanwest",
    "japaneast",
    "brazilsouth",
    "australiaeast",
    "australiasoutheast",
    "southindia",
    "centralindia",
    "westindia",
    "canadacentral",
    "canadaeast",
    "uksouth",
    "ukwest",
    "westcentralus",
    "westus2",
    "koreacentral",
    "koreasouth",
    "francecentral",
    "francesouth",
    "australiacentral",
    "australiacentral2",
    "uaecentral",
    "uaenorth",
    "southafricanorth",
    "southafricawest",
    "switzerlandnorth",
    "switzerlandwest",
    "germanynorth",
    "germanywestcentral",
    "norwaywest",
    "norwayeast",
    "global"
  ]
}