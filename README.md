# Azure Landing Zones with Terraform

A production-oriented Azure Landing Zone reference implementation based on the supplied architecture:

- Management Group / Landing Zone hierarchy
- Platform, Identity, Connectivity, Workload and Sandbox subscription grouping
- Hub-and-spoke networking
- Azure Firewall, Bastion and optional VPN/ExpressRoute gateways
- Central monitoring with Log Analytics
- Shared services for backup and automation
- Azure Policy guardrails
- Optional Microsoft Defender for Cloud
- Standard RBAC patterns
- GitHub Actions CI/CD using Azure federated identity (OIDC)
- Trivy IaC scanning

> **Important:** Azure subscriptions themselves are normally created by the billing/tenant process. This repository organizes existing subscription IDs into the Landing Zone management-group hierarchy. Subscription creation can be automated separately when the required billing permissions/API are available.

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
│   │   └── terraform.tfvars.example
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── variables.tf
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

## Design principles

1. **Platform services are centralized** in the hub and platform subscriptions.
2. **Workloads stay in spokes** and are isolated by subnet, NSG and routing controls.
3. **Internet egress can be inspected** through Azure Firewall using a spoke `0.0.0.0/0` route.
4. **Management access uses Azure Bastion**, avoiding public IPs on workload VMs.
5. **Policy starts in Audit mode** for the supplied examples. Move controls to Deny only after testing.
6. **Secrets never live in Git.** Use GitHub OIDC and environment/secret management.
7. **Remote state is stored in Azure Storage** with state locking.

## Quick start

### 1. Bootstrap Terraform state

Read [`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md).

```powershell
cd bootstrap
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

### 2. Configure the environment

Copy `environments/dev/terraform.tfvars.example` to a local `terraform.tfvars` and fill in your Azure subscription IDs and tenant ID. Do not commit the `.tfvars` file.

### 3. Configure remote state

Update `environments/dev/backend.hcl` with the bootstrap storage account name and initialize:

```powershell
cd environments/dev
terraform init -backend-config=backend.hcl
```

### 4. Run locally

```powershell
terraform fmt -recursive
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### 5. Run CI/CD

Follow [`docs/CICD.md`](docs/CICD.md).

The pull-request workflow performs Terraform format/validation, Trivy IaC scanning and a plan. The deployment workflow performs the same checks and then applies the selected environment after the GitHub Environment approval gate.

## Cost warning

Azure Firewall, Bastion, VPN Gateway, ExpressRoute Gateway, Log Analytics ingestion, Defender for Cloud, public IPs and other platform services can incur charges. The example configuration exposes feature flags so expensive services can be disabled for a lab.

## Reference architecture

```text
                         Internet
                            |
                      Azure Firewall
                            |
                    +----------------+
                    |    Hub VNet    |
                    | DNS / Bastion  |
                    | VPN / ER GW    |
                    | Monitoring     |
                    +-------+--------+
                            |
             +--------------+--------------+
             |              |              |
          Dev Spoke     Prod Spoke    Shared Services
             |              |              |
        VMs/App/etc.   VMs/AKS/SQL    Backup/Automation
```
