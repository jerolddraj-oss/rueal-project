variable "resource_group_name" {
  type    = string
  default = "rg-tfstate"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique, 3-24 lowercase alphanumeric characters."
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "tags" {
  type    = map(string)
  default = {}
}
