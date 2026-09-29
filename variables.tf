variable "name" {
  default     = null
  description = "Name of the analyzer."
}

variable "type" {
  default     = "ACCOUNT"
  description = "What the analyzer looks for (e.g. 'ACCOUNT', 'ORGANIZATION', 'ACCOUNT_UNUSED_ACCESS', 'ORGANIZATION_UNUSED_ACCESS'). The plain types find resources shared outside your zone of trust and are free. The unused-access types find permissions nobody uses and are billed per resource."

  validation {
    condition = contains([
      "ACCOUNT", "ORGANIZATION", "ACCOUNT_UNUSED_ACCESS", "ORGANIZATION_UNUSED_ACCESS",
    ], var.type)
    error_message = "type must be one of 'ACCOUNT', 'ORGANIZATION', 'ACCOUNT_UNUSED_ACCESS' or 'ORGANIZATION_UNUSED_ACCESS'."
  }
}

variable "unused_access_age" {
  default     = null
  description = "How many days a permission must go unused before it is reported. Only meaningful for the unused-access analyzer types. Left null, AWS uses 90."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the analyzer."
}
