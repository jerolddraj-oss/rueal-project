# CI/CD with GitHub Actions

## Authentication

Use GitHub Actions OIDC instead of a long-lived Azure client secret. Create an Entra application/service principal with a federated credential for this repository and grant only the required Azure roles.

Configure these GitHub **Environment** secrets for both `dev` and `prod`:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `TFSTATE_RESOURCE_GROUP`
- `TFSTATE_STORAGE_ACCOUNT`
- `TFSTATE_CONTAINER`

Use separate GitHub Environments and approval rules for production.

## Pipeline

`terraform-pr.yml` is intended for pull requests. It runs formatting, validation and Trivy IaC scanning. Keep real subscription values out of the repository.

`terraform-deploy.yml` is manually triggered and accepts `dev` or `prod` plus `plan` or `apply`. It performs:

1. Checkout
2. Azure OIDC login
3. Terraform installation
4. Format check
5. Remote backend initialization
6. Terraform validation
7. Trivy IaC scan
8. Terraform plan
9. Terraform apply (only when `action=apply`)

## Recommended promotion flow

```text
Developer branch
      |
      v
Pull Request --> fmt + validate + Trivy
      |
      v
Merge to main
      |
      v
Deploy: dev / plan
      |
      v
Review plan + approve GitHub Environment
      |
      v
Deploy: dev / apply
      |
      v
Deploy: prod / plan
      |
      v
Production Environment approval
      |
      v
Deploy: prod / apply
```

## Important

The deployment workflow uses `TF_VAR_*` values for the target subscription and tenant. Other configuration should be supplied through a protected tfvars source or GitHub Environment variables when moving beyond the example baseline. Never commit secrets, service-principal credentials, or real `.tfvars` files.
