locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    LandingZone = "Azure-LZ"
  })
}

module "management_groups" {
  source = "../../modules/management-groups"
  root_management_group_id   = var.root_management_group_id
  landing_zone_name          = "Landing-Zone"
  platform_subscription_ids  = var.platform_subscription_ids
  identity_subscription_ids  = var.identity_subscription_ids
  connectivity_subscription_ids = var.connectivity_subscription_ids
  workload_subscription_ids  = var.workload_subscription_ids
  sandbox_subscription_ids   = var.sandbox_subscription_ids
}

module "hub" {
  source = "../../modules/hub-network"
  name = "${var.name_prefix}-hub"
  resource_group_name = "rg-${var.name_prefix}-hub"
  location = var.location
  address_space = var.hub_address_space
  firewall_subnet_prefix = var.firewall_subnet_prefix
  bastion_subnet_prefix = var.bastion_subnet_prefix
  gateway_subnet_prefix = var.gateway_subnet_prefix
  dns_resolver_subnet_prefix = var.dns_resolver_subnet_prefix
  enable_firewall = var.enable_firewall
  enable_bastion = var.enable_bastion
  enable_vpn_gateway = var.enable_vpn_gateway
  enable_expressroute_gateway = var.enable_expressroute_gateway
  tags = local.common_tags
}

module "spokes" {
  for_each = var.spokes
  source = "../../modules/spoke-network"
  name = each.value.name
  resource_group_name = "rg-${var.name_prefix}-${each.key}"
  location = var.location
  address_space = each.value.address_space
  subnets = each.value.subnets
  hub_vnet_id = module.hub.vnet_id
  hub_vnet_name = module.hub.vnet_name
  hub_resource_group_name = "rg-${var.name_prefix}-hub"
  firewall_private_ip = module.hub.firewall_private_ip
  enable_default_route_to_firewall = var.enable_default_route_to_firewall
  tags = merge(local.common_tags, { Workload = each.key })
}

module "monitoring" {
  source = "../../modules/monitoring"
  name_prefix = var.name_prefix
  location = var.location
  resource_group_name = "rg-${var.name_prefix}-monitoring"
  retention_days = var.log_retention_days
  tags = local.common_tags
}

module "shared_services" {
  source = "../../modules/shared-services"
  name_prefix = var.name_prefix
  location = var.location
  resource_group_name = "rg-${var.name_prefix}-shared"
  enable_automation = var.enable_automation
  tags = local.common_tags
}

module "identity" {
  source = "../../modules/identity"
  name_prefix = var.name_prefix
  location = var.location
  resource_group_name = "rg-${var.name_prefix}-identity"
  tags = local.common_tags
}

module "security" {
  source = "../../modules/security"
  name_prefix = var.name_prefix
  location = var.location
  resource_group_name = "rg-${var.name_prefix}-security"
  tenant_id = var.tenant_id
  tags = local.common_tags
}

module "workload" {
  source = "../../modules/workload"
  location = var.location
  resource_groups = var.workload_resource_groups
  tags = local.common_tags
}

module "policy" {
  source = "../../modules/policy"
  scope_management_group_id = module.management_groups.landing_zone_id
  allowed_locations = [var.location]
  required_tags = ["Environment", "ManagedBy", "LandingZone"]
  policy_effect = var.policy_effect
}
