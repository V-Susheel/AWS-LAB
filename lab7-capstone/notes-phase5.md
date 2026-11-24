# Lab 7 – Phase 5: Fleet health from both clouds

## What I built
- Terraform (via PR + approved pipeline): CloudWatch log group lab7-fleet-health, 7-day retention
- Run Command (by tag): CloudWatch agent on both nodes, shipping /var/log/fleet-health.log
- State Manager association lab7-fleet-health: runs health-check.sh every 30 minutes on Role=fleet-node
- Each run writes one JSON line: instance type, arch, AZ, uptime, disk %, free memory,
  scheduled AWS maintenance (IMDS), Arc agent status, needs_attention + reasons

## Queries
- AWS (CloudWatch Logs Insights): latest status per node; nodes needing attention
- Azure (Resource Graph, KQL): Arc machines not Connected
- Link between clouds: Azure tag AwsInstanceId = EC2 instance_id

## Failure tests
1. Filled x86 disk to ~90% (fallocate) → AWS view flagged disk-high within a minute → removed file
2. Stopped the Arc agent on the Arm node → AWS view flagged arc-not-connected within a minute;
   Azure marked it Disconnected after ~15 minutes → restarted, both views back to healthy
Lesson: the node detects its own problem fast; the control plane confirms it independently.

## Troubleshooting
- Logs Insights: alias can't reuse its field name ("Cycle found in operation dependency graph")
- himdsd restarted itself when stopped (dependent agent services) → used systemctl mask --runtime --now
- Resource Graph: properties.lastStatusChange is when status last changed, not the last heartbeat
