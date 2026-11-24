#!/bin/bash
# Node health as one JSON line -> /var/log/fleet-health.log (shipped to CloudWatch)
set -uo pipefail
TOKEN=$(curl -s -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
md() { curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/$1"; }

INSTANCE_ID=$(md instance-id)
INSTANCE_TYPE=$(md instance-type)
AZ=$(md placement/availability-zone)
MAINT=$(md events/maintenance/scheduled); [ -z "$MAINT" ] && MAINT="[]"
ARCH=$(uname -m)
DISK_PCT=$(df --output=pcent / | tail -1 | tr -dc '0-9')
MEM_MB=$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)
UPTIME_H=$(awk '{print int($1/3600)}' /proc/uptime)
ARC=$(azcmagent show 2>/dev/null | awk -F': *' '/Agent Status/ {print $2; exit}' | tr -d ' ')
ARC=${ARC:-NotInstalled}

REASONS=()
[ "$MAINT" != "[]" ]       && REASONS+=("maintenance-scheduled")
[ "$DISK_PCT" -ge 80 ]     && REASONS+=("disk-high")
[ "$MEM_MB" -lt 100 ]      && REASONS+=("memory-low")
[ "$ARC" != "Connected" ]  && REASONS+=("arc-not-connected")
if [ ${#REASONS[@]} -gt 0 ]; then ATTN=yes; else ATTN=no; fi
REASON_TEXT=$(IFS=,; echo "${REASONS[*]}")

printf '{"time":"%s","instance_id":"%s","instance_type":"%s","arch":"%s","az":"%s","uptime_hours":%d,"disk_used_pct":%d,"mem_available_mb":%d,"arc_status":"%s","maintenance":%s,"needs_attention":"%s","reasons":"%s"}\n' \
  "$(date -u +%FT%TZ)" "$INSTANCE_ID" "$INSTANCE_TYPE" "$ARCH" "$AZ" "$UPTIME_H" "$DISK_PCT" "$MEM_MB" "$ARC" "$MAINT" "$ATTN" "$REASON_TEXT" \
  | tee -a /var/log/fleet-health.log
