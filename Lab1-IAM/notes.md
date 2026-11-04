# Lab 1 – IAM
## What I built
- S3 bucket + least-privilege read policy, tested with the IAM policy simulator
- EC2 role (trust policy + AmazonSSMManagedInstanceCore) and instance profile for Lab 3
## What I learned
- Bucket vs object ARNs: ...
- Policy evaluation: explicit Deny > Allow > implicit deny
- Trust policy (who) vs permissions policy (what)
- Instance profile: ...
## Troubleshooting
- simulate-custom-policy failed with InvalidInput even though the JSON was valid;
  the CLI was re-parsing the JSON. Fixed by passing the policy as a JSON string list with jq.
