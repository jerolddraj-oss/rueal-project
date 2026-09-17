# Azure Landing Zones with Terraform

A modular Azure Landing Zone reference implementation based on the supplied architecture drawing.

## What is included

- Management Group / Landing Zone hierarchy
- Platform, Identity, Connectivity, Workload and Sandbox subscription grouping
- Hub-and-spoke networking
- Azure Firewall, Bastion and optional VPN/ExpressRoute gateways
- Private DNS Resolver in the hub
- Dev/Prod spoke templates with workload subnets and NSGs
- Central Log Analytics workspace and Monitor Action Group
- Recovery Services Vault and optional Automation Account
- User-assigned managed identity
- RBAC-enabled Azure Key Vault
- Azure Policy guardrails for allowed locations and required tags
- Generic RBAC assignment module
- Workload resource-group module
- GitHub Actions CI/CD using Azure federated identity (OIDC)
- Trivy IaC scanning
- Separate Terraform state keys for Dev and Prod

> **Important:** Azure subscriptions themselves are normally created by the billing/tenant process. This repository organizes existing subscription IDs into the Landing Zone management-group hierarchy. Subscription creation is intentionally outside the Terraform baseline.

## Repository structure

```text
.
├── .github/workflows/
│   ├── terraform-pr.yml
│   └── terraform-deploy.yml
├── bootstrap/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── docs/
│   ├── ARCHITECTURE.md
│   ├── BOOTSTRAP.md
│   └── CICD.md
├── environments/
│   ├── dev/
│   │   ├── backend.hcl
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── terraform.tfvars.example
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── terraform.tfvars.example
└── modules/
    ├── hub-network/
    ├── identity/
    ├── management-groups/
    ├── monitoring/
    ├── policy/
    ├── role-assignments/
    ├── security/
    ├── shared-services/
    ├── spoke-network/
    └── workload/
```

## Architecture mapping

| Drawing area | Terraform implementation |
|---|---|
| Subscription / Project Structure | `modules/management-groups` + environment subscription ID lists |
| Hub VNet | `modules/hub-network` |
| Dev / Prod / App spokes | `modules/spoke-network` |
| Shared services | `modules/shared-services` |
| Monitoring | `modules/monitoring` |
| Identity | `modules/identity` |
| Security | `modules/security` |
| Policy framework | `modules/policy` |
| RBAC | `modules/role-assignments` |
| Workload resource groups | `modules/workload` |

## Deployment sequence

1. Bootstrap the remote Terraform state storage account.
2. Configure the Dev/Prod environment values.
3. Run local `fmt`, `init`, `validate` and `plan`.
4. Configure GitHub OIDC and protected Environment secrets.
5. Open a pull request: formatting, validation and Trivy run automatically.
6. After merge, run `Terraform Deploy` with `plan` for the target environment.
7. Review the plan and use the protected GitHub Environment approval before `apply`.

## Local commands

```powershell
cd bootstrap
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply

cd ../environments/dev
Copy-Item terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive ../../modules .
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Design principles

1. Platform services are centralized in the hub/platform layer.
2. Workloads stay in spokes and are isolated with subnet and NSG controls.
3. Spoke egress can be inspected through Azure Firewall using a default route to the firewall private IP.
4. Administrative VM access can use Azure Bastion instead of public VM IPs.
5. Policy starts in Audit mode; move controls to Deny only after testing.
6. Secrets do not live in Git. GitHub Actions uses OIDC.
7. Remote state uses Azure Storage with Entra authentication.
8. Databases should use private endpoints/private DNS and must not be directly exposed to the Internet.

## Cost warning

Azure Firewall, Bastion, VPN Gateway, ExpressRoute Gateway, Log Analytics ingestion, Key Vault and Automation can incur charges. The example environment disables expensive services by default so the repository can be used as a controlled lab starting point.
