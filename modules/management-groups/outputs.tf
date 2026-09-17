output "landing_zone_id" {
  value = azurerm_management_group.landing_zone.id
}

output "platform_id" {
  value = azurerm_management_group.platform.id
}

output "identity_id" {
  value = azurerm_management_group.identity.id
}

output "connectivity_id" {
  value = azurerm_management_group.connectivity.id
}

output "management_id" {
  value = azurerm_management_group.management.id
}

output "workloads_id" {
  value = azurerm_management_group.workloads.id
}

output "sandbox_id" {
  value = azurerm_management_group.sandbox.id
}
