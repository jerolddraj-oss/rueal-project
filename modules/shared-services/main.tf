resource "azurerm_resource_group" "this" {
  name = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_recovery_services_vault" "backup" {
  name = "${var.name_prefix}-rsv"
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "Standard"
  soft_delete_enabled = true
  storage_mode_type = "GeoRedundant"
  tags = var.tags
}

resource "azurerm_automation_account" "this" {
  count = var.enable_automation ? 1 : 0
  name = "${var.name_prefix}-automation"
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name = "Basic"
  identity { type = "SystemAssigned" }
  tags = var.tags
}
