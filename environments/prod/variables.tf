variable "subscription_id" { type = string }
variable "tenant_id" { type = string }
variable "root_management_group_id" { type = string }
variable "location" { type = string default = "East US" }
variable "environment" { type = string }
variable "name_prefix" { type = string }
variable "platform_subscription_ids" { type = list(string) default = [] }
variable "identity_subscription_ids" { type = list(string) default = [] }
variable "connectivity_subscription_ids" { type = list(string) default = [] }
variable "workload_subscription_ids" { type = list(string) default = [] }
variable "sandbox_subscription_ids" { type = list(string) default = [] }
variable "hub_address_space" { type = list(string) default = ["10.0.0.0/16"] }
variable "firewall_subnet_prefix" { type = string default = "10.0.0.0/24" }
variable "bastion_subnet_prefix" { type = string default = "10.0.1.0/26" }
variable "gateway_subnet_prefix" { type = string default = "10.0.2.0/27" }
variable "dns_resolver_subnet_prefix" { type = string default = "10.0.3.0/28" }
variable "enable_firewall" { type = bool default = true }
variable "enable_bastion" { type = bool default = true }
variable "enable_vpn_gateway" { type = bool default = false }
variable "enable_expressroute_gateway" { type = bool default = false }
variable "enable_default_route_to_firewall" { type = bool default = true }
variable "log_retention_days" { type = number default = 30 }
variable "enable_automation" { type = bool default = false }
variable "policy_effect" { type = string default = "Audit" validation { condition = contains(["Audit", "Deny"], var.policy_effect) error_message = "policy_effect must be Audit or Deny." } }
variable "tags" { type = map(string) default = {} }
variable "spokes" {
  type = map(object({
    name = string
    address_space = list(string)
    subnets = map(object({ address_prefixes = list(string) }))
  }))
  default = {}
}
variable "workload_resource_groups" { type = set(string) default = [] }
