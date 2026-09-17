output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "firewall_private_ip" {
  value = try(azurerm_firewall.main[0].ip_configuration[0].private_ip_address, null)
}

output "firewall_id" {
  value = try(azurerm_firewall.main[0].id, null)
}

output "dns_resolver_inbound_ip" {
  value = try(azurerm_private_dns_resolver_inbound_endpoint.inbound.ip_configurations[0].private_ip_address, null)
}
