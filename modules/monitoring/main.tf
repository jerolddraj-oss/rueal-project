resource "azurerm_resource_group" "this" {
  name = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name = var.name_prefix
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku = "PerGB2018"
  retention_in_days = var.retention_days
  internet_ingestion_enabled = true
  internet_query_enabled = true
  tags = var.tags
}

resource "azurerm_monitor_action_group" "platform" {
  name = "${var.name_prefix}-alerts"
  resource_group_name = azurerm_resource_group.this.name
  short_name = "lzalert"
  tags = var.tags
}
