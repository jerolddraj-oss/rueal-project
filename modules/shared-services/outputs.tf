output "recovery_vault_id" { value = azurerm_recovery_services_vault.backup.id }
output "automation_account_id" { value = try(azurerm_automation_account.this[0].id, null) }
