# GitHub Actions CI/CD

## Authentication model

Use GitHub Actions OIDC/federated identity with Azure. Do not store an Azure client secret in the repository.

```text
GitHub repository
      |
      | OIDC token
      v
Microsoft Entra ID
      |
      v
Azure deployment identity
      |
      v
Landing Zone subscriptions
```

## GitHub Environment secrets

Configure these in the `dev` and `prod` GitHub Environments:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID` (used by `azure/login`)
- `CONNECTIVITY_SUBSCRIPTION_ID`
- `PLATFORM_SUBSCRIPTION_ID`
- `IDENTITY_SUBSCRIPTION_ID`
- `WORKLOAD_SUBSCRIPTION_ID`
- `SANDBOX_SUBSCRIPTION_ID`

For `prod`, configure required reviewers before enabling deployment.

## Pull request pipeline

`.github/workflows/terraform-pr.yml`:

1. checkout
2. Azure login with OIDC
3. Terraform format check
4. Terraform init
5. Terraform validate
6. Trivy IaC scan
7. Terraform plan

The PR workflow does not apply changes.

## Deployment pipeline

`.github/workflows/terraform-deploy.yml`:

- runs on pushes to `main`
- can also be started manually
- validates the selected environment
- creates a Terraform plan
- applies the plan after the GitHub Environment approval gate

## First-time setup

1. Bootstrap Terraform state manually.
2. Create the Azure federated identity.
3. Assign required Azure RBAC.
4. Create GitHub `dev` and `prod` environments.
5. Add the environment secrets listed above.
6. Protect `main`.
7. Create a PR.
8. Confirm the plan and security scan.
9. Merge to `main`.
10. Approve the deployment environment.

## Local commands

```powershell
terraform fmt -recursive
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
