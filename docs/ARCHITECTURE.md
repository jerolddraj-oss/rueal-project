# Architecture and module responsibilities

## 1. Management Group hierarchy

```text
Tenant Root
└── Landing Zone
    ├── Platform
    │   ├── Connectivity
    │   ├── Identity
    │   └── Management
    ├── Workloads
    │   ├── Dev
    │   └── Prod
    └── Sandbox
```

The hierarchy is implemented with `azurerm_management_group`. Existing subscriptions are attached with `azurerm_management_group_subscription_association`.

## 2. Network flow

The hub contains:

- Azure Firewall
- Azure Bastion
- DNS resolver
- optional VPN Gateway
- optional ExpressRoute Gateway

Each spoke is connected to the hub using VNet peering.

For controlled egress, the spoke route table sends:

```text
0.0.0.0/0 -> Azure Firewall private IP
```

## 3. Security boundaries

- NSGs on workload subnets
- Azure Firewall for centralized network inspection
- Bastion for administrative access
- RBAC with least privilege
- Azure Policy at management-group scope
- Defender for Cloud is optional
- No workload VM requires a public IP by default

## 4. Policy model

The policy module demonstrates audit-first controls:

- Allowed locations
- Require resource tags

The assignment `enforcement_mode` is set to `DoNotEnforce` when `policy_effect = "Audit"`. After validation, set `policy_effect = "Deny"` to enforce the assignments.

## 5. Disaster recovery

The shared-services module creates a Recovery Services Vault and Automation Account. Backup policies and workload-specific replication should be added per workload RTO/RPO requirements. Azure Site Recovery is not enabled automatically because recovery plans are application-specific.

## 6. Terraform state

Each environment has its own Azure Storage backend:

```text
tfstate
├── landing-zone/dev.tfstate
└── landing-zone/prod.tfstate
```

Enable storage network restrictions/private endpoints where practical and use Entra ID/RBAC for state access.

## 7. Production hardening checklist

- Enable storage firewall/private endpoint for Terraform state.
- Use GitHub OIDC rather than long-lived Azure client secrets.
- Configure GitHub Environment approvals.
- Enable branch protection and PR review.
- Add Checkov or Microsoft Defender for DevOps if required.
- Move policy controls from Audit to Deny only after testing.
- Add Azure Firewall rules/application rules/network rules.
- Add Private DNS zones and private endpoints for PaaS services.
- Add Azure Monitor alerts and action groups.
- Add backup policies and ASR recovery plans.
- Add cost budgets.
- Add Azure Policy initiatives aligned to the organization's compliance framework.
