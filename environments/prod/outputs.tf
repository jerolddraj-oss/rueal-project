output "hub_vnet_id" { value = module.hub.vnet_id }
output "hub_firewall_private_ip" { value = module.hub.firewall_private_ip }
output "hub_dns_resolver_inbound_ip" { value = module.hub.dns_resolver_inbound_ip }
output "log_analytics_workspace_id" { value = module.monitoring.workspace_id }
output "identity_id" { value = module.identity.identity_id }
output "key_vault_id" { value = module.security.key_vault_id }
output "spoke_vnet_ids" { value = { for k, v in module.spokes : k => v.vnet_id } }
