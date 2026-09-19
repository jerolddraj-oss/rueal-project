# Kitchen Inventory Application Platform

## Scope

The workload is designed for kitchen inventory, vendor management and purchase/receiving transactions.

Core domains:

- Outlets
- Inventory master
- Inventory transactions
- Vendors
- Vendor items
- Purchase orders
- Goods received / purchased inventory
- Batch and expiry tracking
- Users and application roles
- Audit history
- Reporting

## Security baseline

- Microsoft Entra ID for workforce authentication
- Application-level RBAC
- Managed Identity for Azure resources
- Azure Key Vault for secrets
- Private SQL endpoint and private storage endpoint
- No direct public database access
- WAF at the edge
- Centralized logging and monitoring

## High availability baseline

- Minimum two application replicas
- Zone-aware SQL where the selected Azure SQL SKU/region supports it
- ZRS storage by default for the primary region
- Secondary-region recovery design to be added as an explicit DR environment
- GitHub Actions OIDC for deployments

## Transaction model

Purchasing should create immutable transaction records instead of overwriting stock. Example: current stock 100 KG + received purchase 50 KG = 150 KG, with the 50 KG retained as a purchase/receipt transaction for audit and reporting.
