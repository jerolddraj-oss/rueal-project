data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag on resources"
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "lz-allowed-locations"
  display_name         = "Landing Zone - Allowed locations"
  management_group_id  = var.scope_management_group_id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  enforcement_mode     = var.policy_effect == "Deny" ? "Default" : "DoNotEnforce"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_management_group_policy_assignment" "required_tags" {
  for_each = toset(var.required_tags)

  name                 = "lz-require-tag-${lower(each.value)}"
  display_name         = "Landing Zone - Require ${each.value} tag"
  management_group_id  = var.scope_management_group_id
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  enforcement_mode     = var.policy_effect == "Deny" ? "Default" : "DoNotEnforce"

  parameters = jsonencode({
    tagName = {
      value = each.value
    }
  })
}
