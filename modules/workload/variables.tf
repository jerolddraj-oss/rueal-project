variable "location" { type = string }
variable "resource_groups" { type = set(string) default = [] }
variable "tags" { type = map(string) default = {} }
