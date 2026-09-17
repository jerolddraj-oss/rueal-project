variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "enable_automation" { type = bool default = false }
variable "tags" { type = map(string) default = {} }
