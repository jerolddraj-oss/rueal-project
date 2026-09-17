resource "azurerm_resource_group" "this" {
  name = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_user_assigned_identity" "this" {
  name = "${var.name_prefix}-uai"
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags = var.tags
}
