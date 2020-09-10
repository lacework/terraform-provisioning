variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
  default     = "West US 2"
}

# NOTE: this prefix is used in all resources and we have a limitatino with the
# storage name that can only consist of lowercase letters and numbers, and must
# be between 3 and 24 characters long
variable "prefix" {
  type        = string
  default     = "l4c3w0rk"
  description = "The prefix that will be use at the beginning of every generated resource"
}

variable "application_name" {
  type        = string
  default     = "lacework_security_audit"
  description = "The name of the Azure Active Directory Applicaiton"
}

# TODO @afiune do we need this?
variable "application_identifier_uris" {
  type        = list(string)
  description = "A list of user-defined URI(s) for the Lacework AD Application"
  default = [
    "https://securityaudit.lacework.net"
  ]
}

variable "subscription_ids" {
  type        = list(string)
  description = "List of subscriptions to grant read access to, by default the module will only use the primary subscription"
  default     = []
}

variable "all_subscriptions" {
  type        = bool
  default     = false
  description = "If set to true, grant read access to ALL subscriptions within the selected Tenant (overrides 'subscription_ids')"
}

# If some of the subscriptions use Key Vault services, we need to the
# Azure App to have access to each Key Vault used in your subscriptions.
variable "key_vault_ids" {
  type        = list(string)
  description = "A list of Key Vault Ids used in your subscription for the Lacework AD App to have access to"
  default     = []
}

variable "tenant_id" {
  type        = string
  default     = ""
  description = "A Tenant ID different from the default defined inside the provider"
}

variable "password_length" {
  type        = number
  default     = 30
  description = "The length of the Lacework AD Application password"
}

variable "wait_time" {
  type        = string
  default     = "10s"
  description = "Amount of time to wait before the Lacework resources are provisioned"
}

variable "lacework_integration_name" {
  type    = string
  default = "TF activity log"
}

variable "use_existing_ad_application" {
  type        = bool
  default     = false
  description = "Set this to true to use an existing Active Directory Application"
}

variable "application_id" {
  type        = string
  default     = ""
  description = "The Active Directory Application id to use (required when use_existing_ad_application is set to true)"
}

variable "application_password" {
  type        = string
  default     = ""
  description = "The Active Directory Application password to use (required when use_existing_ad_application is set to true)"
}

variable "service_principal_id" {
  type        = string
  default     = ""
  description = "The Service Principal id to use (required when use_existing_ad_application is set to true)"
}

variable "log_profile_locations" {
  type        = list(string)
  description = "List of regions for which Activity Log events are stored or streamed"
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
