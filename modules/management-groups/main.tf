resource "azurerm_management_group" "landing_zone" {
  display_name                 = var.landing_zone_name
  name                         = var.landing_zone_name
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_id}"
}

resource "azurerm_management_group" "platform" {
  display_name                = "Platform"
  name                        = "${var.landing_zone_name}-Platform"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}

resource "azurerm_management_group" "identity" {
  display_name                = "Identity"
  name                        = "${var.landing_zone_name}-Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  display_name                = "Connectivity"
  name                        = "${var.landing_zone_name}-Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  display_name                = "Management"
  name                        = "${var.landing_zone_name}-Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "workloads" {
  display_name                = "Workloads"
  name                        = "${var.landing_zone_name}-Workloads"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}

resource "azurerm_management_group" "sandbox" {
  display_name                = "Sandbox"
  name                        = "${var.landing_zone_name}-Sandbox"
  parent_management_group_id = azurerm_management_group.landing_zone.id
}

resource "azurerm_management_group_subscription_association" "platform" {
  for_each            = toset(var.platform_subscription_ids)
  management_group_id = azurerm_management_group.platform.id
  subscription_id     = each.value
}

resource "azurerm_management_group_subscription_association" "identity" {
  for_each            = toset(var.identity_subscription_ids)
  management_group_id = azurerm_management_group.identity.id
  subscription_id     = each.value
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  for_each            = toset(var.connectivity_subscription_ids)
  management_group_id = azurerm_management_group.connectivity.id
  subscription_id     = each.value
}

resource "azurerm_management_group_subscription_association" "workloads" {
  for_each            = toset(var.workload_subscription_ids)
  management_group_id = azurerm_management_group.workloads.id
  subscription_id     = each.value
}

resource "azurerm_management_group_subscription_association" "sandbox" {
  for_each            = toset(var.sandbox_subscription_ids)
  management_group_id = azurerm_management_group.sandbox.id
  subscription_id     = each.value
}
