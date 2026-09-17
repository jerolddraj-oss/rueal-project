# Bootstrap instructions

Terraform cannot use an Azure Storage backend until the storage account and container exist. This repository therefore uses a small local-state bootstrap stack.

## Step 1 — Sign in

```powershell
az login
az account set --subscription "<BOOTSTRAP-SUBSCRIPTION-ID>"
```

## Step 2 — Deploy state storage

```powershell
cd bootstrap
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Record the outputs:

```text
resource_group_name
storage_account_name
container_name
```

## Step 3 — Configure environment backend

Edit `environments/dev/backend.hcl`:

```hcl
resource_group_name  = "rg-tfstate"
storage_account_name = "sttfstate12345"
container_name       = "tfstate"
key                  = "landing-zone/dev.tfstate"
use_azuread_auth     = true
```

## Step 4 — Reinitialize

```powershell
cd ../environments/dev
terraform init -backend-config=backend.hcl
```

If moving from local state to remote state:

```powershell
terraform init -migrate-state -backend-config=backend.hcl
```

## Step 5 — Protect the state

The state file may contain sensitive values. Treat the storage account as a security boundary:

- restrict network access
- enable blob versioning
- enable soft delete
- use RBAC
- restrict owner/contributor permissions
- monitor access
