variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_resource_group_name" {
  type = string
}

variable "firewall_private_ip" {
  type    = string
  default = null
}

variable "enable_default_route_to_firewall" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
