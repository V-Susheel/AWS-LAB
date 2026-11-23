# Lab 7 – Phase 4: Onboard AWS EC2 nodes to Azure Arc

## What I built
- Azure: resource group rg-lab7-arc; service principal sp-lab7-arc-onboard with ONLY
  the "Azure Connected Machine Onboarding" role, scoped to that resource group
- AWS: Arc settings in SSM Parameter Store under /lab7/arc/ — IDs as String,
  the SP secret as SecureString (KMS-encrypted). No IDs or secrets in GitHub.
- SSM Run Command (AWS-RunShellScript) targeted by tag Role=fleet-node ran
  scripts/onboard-arc.sh on both nodes: installs the Azure Connected Machine agent,
  then azcmagent connect
- Result: both EC2 nodes (x86-64 and Graviton aarch64) show as Connected in
  Azure Arc, with tags Source=aws and AwsInstanceId

## Design points
- Secret handling: script reads parameter NAMES; values fetched at run time
  (Azure equivalent: Key Vault)
- Least privilege: onboarding SP can only create Arc machines in one RG
- Network: agent connects OUTBOUND over HTTPS 443; security group still has no inbound rules
- Targeting by tag, not instance ID → works after Terraform rebuilds nodes
- Idempotent script: skips install if the agent exists, exits if already connected

## Two control planes, one fleet
- AWS Fleet Manager and Azure Arc → Machines show the same two servers
- Azure Resource Graph (KQL) query in queries/arc-fleet.kql lists status, OS,
  agent version and detected hardware (cloud provider, processor, cores, memory)

## Troubleshooting
- First Run Command failed: curl exit 23 (write error) on both nodes. Ran each step
  by hand in Session Manager: download and agent install worked, so the failure was
  writing to /tmp. Moved the download to /root and made install conditional. Re-ran
  Run Command → both Connected.
- Confirmed the Arc agent supports Amazon Linux 2023 on Arm64 (aarch64 package installed)
