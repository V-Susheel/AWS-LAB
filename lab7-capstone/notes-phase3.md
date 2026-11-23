# Lab 7 – Phase 3: GitHub Actions pipeline with OIDC

## Flow
PR → plan job (fmt, init, validate, plan) → plan posted as PR comment →
merge → apply job waits for approval (environment "lab") → apply.
Manual destroy via workflow_dispatch, also approval-gated.

## Authentication (no stored keys)
- IAM OIDC provider for token.actions.githubusercontent.com (audience sts.amazonaws.com)
- Role github-actions-lab7, trust policy limited to this repo using GitHub's
  immutable sub format: repo:V-Susheel@<owner-id>/AWS-LAB@<repo-id>:*
- Temporary credentials (~1 hour) per run

## Least privilege
- PowerUserAccess (everything except IAM) + inline policy allowing IAM actions
  only on lab7-* roles and instance profiles

## Proof of a change
Added Owner tag in providers.tf → PR plan showed "~ update in-place",
0 to add / 0 to destroy → merged → approved → tag visible on EC2.

## Troubleshooting
1. "Not authorized to perform sts:AssumeRoleWithWebIdentity": decoded token claims,
   found GitHub's ID-based sub format, updated the trust policy
2. S3 403 on state: simulator first showed an SCP explicit deny, but only because no
   region was passed (region SCP). With aws:RequestedRegion set it showed implicitDeny:
   the role had no permission policies. Attached them, verified, re-ran.
3. Push rejected: token needed the Workflows permission to change workflow files
