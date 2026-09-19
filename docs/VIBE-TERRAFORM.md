# Vibe Terraform Workflow

This repository uses an AI-assisted infrastructure workflow: describe the desired architecture, generate or modify Terraform, validate it, scan it, review the plan and then deploy.

## Guardrails

1. Never commit secrets or real tfvars.
2. Use GitHub Actions OIDC instead of long-lived Azure client secrets.
3. Run `terraform fmt`, `terraform validate` and `terraform plan` for every environment change.
4. Run Trivy IaC scanning before deployment.
5. Require human review of Terraform plans.
6. Keep production deployment behind a protected GitHub Environment.

## Target platform

Azure Hub-Spoke Landing Zone + Kitchen Inventory application workload + private data services + centralized monitoring + regional DR.
