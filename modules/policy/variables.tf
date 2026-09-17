variable "scope_management_group_id" {
  type = string
}

variable "allowed_locations" {
  type    = list(string)
  default = ["eastus"]
}

variable "policy_effect" {
  type        = string
  description = "Audit or Deny. Start with Audit, then move to Deny after testing."
  default     = "Audit"

  validation {
    condition     = contains(["Audit", "Deny"], var.policy_effect)
    error_message = "policy_effect must be Audit or Deny."
  }
}

variable "required_tags" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
