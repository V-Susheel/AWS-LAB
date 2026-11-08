# AWS Hands-on Labs

Hands-on labs I built to learn AWS from an Azure background, and to compare compute hardware across both clouds. Every lab was built and tested in my own AWS account (and my own Azure subscription for comparisons).

**Author:** Susheel Vemaraju, Azure Cloud Engineer (8+ years)
**Region used:** AWS us-east-2 (Ohio)

## Labs

| # | Lab | What I built | Azure equivalent | Status |
|---|-----|--------------|------------------|--------|
| 0 | Account setup | New AWS project-based account on the Free plan: sign-in MFA, region check, CloudShell identity check | Tenant + subscription setup | Completed|
| 1 | IAM | Read-only group, least-privilege S3 policy, EC2 role for Systems Manager | Entra ID, RBAC, Managed Identity | Completed |
| 2 | VPC networking | VPC with public/private subnets across 2 AZs, IGW, NAT, route tables | VNet, subnets, UDRs | Completed |
| 3 | EC2 | Linux instance with user data, connected through Session Manager (no SSH keys) | VM + Bastion/JIT | Completed |
| 4 | Auto Scaling + ALB | Launch template, Auto Scaling Group, Application Load Balancer | VMSS + App Gateway | Completed |
| 5 | S3 + CloudWatch | Versioned, encrypted bucket; logs and a Logs Insights query | Storage account, Log Analytics + KQL | Not started |
| 6 | Cloud hardware | Arm vs x86 benchmark, instance catalog script, maintenance-event script | Cobalt vs x86, Scheduled Events | Not started |
| 7 | Capstone | Terraform + GitHub Actions, EC2 onboarded to Systems Manager and Azure Arc | Arc-enabled servers | Not started |

## Folder layout

```
lab0-setup/       notes.md, screenshots
lab1-iam/         policy JSON files, commands.sh, notes.md
lab2-vpc/         commands.sh, diagram.png, notes.md
...
```

Each `notes.md` covers: what I built, the commands I ran, what surprised me coming from Azure, and how I cleaned up.

## Cost control

- $10 monthly budget alert
- Every lab ends with a cleanup step
