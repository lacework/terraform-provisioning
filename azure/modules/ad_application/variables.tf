variable "create" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "application_name" {
  type        = string
  default     = "lacework_security_audit"
  description = "The name of the Azure Active Directory Applicaiton"
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

# If some of the subscriptions use Key Vault services, we need to the
# Azure App to have access to each Key Vault used in your subscriptions.
variable "key_vault_ids" {
  type        = list(string)
  description = "A list of Key Vault Ids used in your subscription for the Lacework AD App to have access to"
  default     = []
}

# TODO @afiune do we need this?
variable "application_identifier_uris" {
  type        = list(string)
  description = "A list of user-defined URI(s) for the Lacework AD Application"
  default = [
    "https://securityaudit.lacework.net"
  ]
}
