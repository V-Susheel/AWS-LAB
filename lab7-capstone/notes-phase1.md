# Lab 7 – Phase 1: AWS infrastructure with Terraform

## What I built (12 resources, from CloudShell)
- VPC 10.20.0.0/16, internet gateway, public subnet, route table + association
- Security group with NO inbound rules (SSM and Arc only need outbound)
- IAM role (trust: EC2) + SSM and CloudWatch policies + instance profile
- Two EC2 nodes with for_each: t4g.micro (Graviton/Arm) and t3.micro (x86),
  newest Amazon Linux 2023 image looked up with a data source, IMDSv2 required
- default_tags: Project=lab7-capstone, ManagedBy=terraform on every resource

## Workflow
init → fmt → validate → plan (12 to add) → apply → console check → drift test → destroy

## Drift test
Changed the VPC Name tag by hand in the console; terraform plan showed
`~ update in-place` and apply restored it. Code is the source of truth.

## Terraform vs ARM
| Terraform | ARM |
|---|---|
| plan | what-if |
| variable | parameter |
| for_each | copy loop |
| data source | existing resource / reference() |
| state file | none — Azure is the record |
