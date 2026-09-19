# Kitchen Inventory Platform - Vibe Terraform

This repository is the Azure Landing Zone and workload foundation for a secure, highly available Kitchen Inventory application.

## Application scope

- Central kitchen inventory
- Multi-outlet inventory
- Veg / non-veg inventory classification
- Vendor master and vendor-item mapping
- Purchase orders and purchased inventory / goods received
- Batch and expiry tracking
- Stock in, stock out and outlet transfer
- Application users, roles and permissions
- Audit trail and reporting

## Architecture

```text
Internet
   |
Azure Front Door + WAF
   |
Application platform
   |
Azure Container Apps (minimum 2 replicas)
   |
Private Endpoint
   |
Azure SQL Database (private, zone-redundant where supported)
   |
Backups / secondary-region DR

Cross-cutting:
Entra ID | Managed Identity | Key Vault | Private Endpoints
Azure Firewall | NSGs | Log Analytics | Defender | GitHub OIDC
```

The existing Landing Zone modules remain the platform foundation. The new kitchen workload modules are designed to consume the landing-zone network and monitoring outputs.

## Repository structure

```text
.
├── bootstrap/
├── modules/
│   ├── hub-network/
│   ├── spoke-network/
│   ├── management-groups/
│   ├── policy/
│   ├── security/
│   ├── identity/
│   ├── monitoring/
│   ├── shared-services/
│   ├── role-assignments/
│   ├── workload/
│   ├── kitchen-platform/
│   ├── container-app/
│   └── sql-private/
├── environments/
│   ├── dev/
│   └── prod/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── BOOTSTRAP.md
│   ├── CICD.md
│   ├── KITCHEN-APPLICATION.md
│   └── VIBE-TERRAFORM.md
└── .github/workflows/
    ├── terraform-pr.yml
    └── terraform-deploy.yml
```

## Important security decisions

- SQL Server public network access is disabled.
- SQL is consumed through a Private Endpoint.
- Storage public network access is disabled.
- Key Vault public network access is disabled.
- Workload identity uses managed identity.
- GitHub Actions uses OIDC instead of long-lived client secrets.
- Secrets and real tfvars must never be committed.
- Production deployment should use a protected GitHub Environment.

## Vibe Terraform workflow

```text
Requirement
   ↓
AI-assisted Terraform change
   ↓
terraform fmt
   ↓
terraform validate
   ↓
Trivy / Checkov
   ↓
terraform plan
   ↓
Human review
   ↓
GitHub Environment approval
   ↓
terraform apply
```

## Next implementation stages

1. Wire the new `kitchen-platform` module into dev/prod using existing spoke subnets and Log Analytics.
2. Add Private DNS zones and links for SQL and Storage.
3. Add edge routing/WAF using the selected Azure ingress design.
4. Add application CI/CD for frontend and API container images.
5. Add the kitchen application database schema and migrations.
6. Add secondary-region DR and documented recovery procedures.
7. Validate the complete environment with Terraform plan and IaC security scans before any apply.
