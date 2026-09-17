output "vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "resource_group_id" {
  value = azurerm_resource_group.spoke.id
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.workload : k => v.id }
}
