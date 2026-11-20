# Lab 7 – Phase 2: Git workflow + S3 remote state

## Remote state
- State bucket created once by CLI (bootstrap: Terraform can't store state in a bucket it hasn't made yet)
- Versioning on (roll back a bad state), public access blocked, encrypted
- backend.tf: bucket, key lab7/terraform.tfstate, encrypt, use_lockfile (native S3 locking)
- After apply, no local terraform.tfstate — it lives in S3, one version per apply

## Lock test
Held the lock with `terraform apply` at the prompt in one CloudShell tab;
`terraform plan` in a second tab failed with "Error acquiring the state lock".
Locking prevents two runs from corrupting state.

## Git workflow
clone → branch (phase2-remote-state) → add/commit → push → pull request →
review "Files changed" → merge → delete branch → pull main
- Fine-grained token scoped to one repo, Contents read/write, 30-day expiry
- Committed .terraform.lock.hcl (pins provider version); .gitignore excludes state and .terraform/

## Azure comparison
- S3 backend ≈ azurerm backend in a storage account (lease = lock)
- Pull request flow = same as Azure Repos PRs
