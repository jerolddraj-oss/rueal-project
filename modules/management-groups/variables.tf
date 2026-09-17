variable "root_management_group_id" {
  type        = string
  description = "Management group ID under the tenant root. Usually the tenant ID."
}

variable "landing_zone_name" {
  type    = string
  default = "Landing-Zone"
}

variable "platform_subscription_ids" {
  type    = list(string)
  default = []
}

variable "identity_subscription_ids" {
  type    = list(string)
  default = []
}

variable "connectivity_subscription_ids" {
  type    = list(string)
  default = []
}

variable "workload_subscription_ids" {
  type    = list(string)
  default = []
}

variable "sandbox_subscription_ids" {
  type    = list(string)
  default = []
}
