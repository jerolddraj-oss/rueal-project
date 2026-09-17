data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name = var.name_prefix
  location = var.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id = var.tenant_id
  sku_name = "standard"
  purge_protection_enabled = true
  soft_delete_retention_days = 90
  enable_rbac_authorization = true
  public_network_access_enabled = true
  tags = var.tags
}
