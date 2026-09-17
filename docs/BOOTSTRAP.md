# Bootstrap and first deployment

## 1. Azure prerequisites

Use an Azure identity with permission to create the Terraform state resource group/storage account and, for the landing-zone deployment, permission to manage management groups, policy assignments, RBAC and resources in the target subscription.

Create the state store once:

```powershell
cd bootstrap
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Use a globally unique lowercase storage account name. The bootstrap module creates a ZRS storage account, private state container, blob versioning and retention controls.

## 2. Local deployment

```powershell
cd environments/dev
Copy-Item terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars
terraform init -backend-config=backend.hcl
terraform fmt -check -recursive ../../modules .
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

For production, use `environments/prod` and its separate state key.

## 3. Required values

- `subscription_id`: target Azure subscription used for platform resources.
- `tenant_id`: Microsoft Entra tenant ID.
- `root_management_group_id`: tenant root management-group ID; normally the tenant ID when the tenant root group is being used.
- Subscription ID lists: existing subscriptions to associate with Platform/Identity/Connectivity/Workloads/Sandbox.
- CIDRs: must not overlap with on-premises, VPN or other spokes.

## 4. Cost controls

For a lab, keep Firewall, Bastion, VPN/ER gateway and Automation disabled. Enable them only when needed. Policy is Audit by default.
