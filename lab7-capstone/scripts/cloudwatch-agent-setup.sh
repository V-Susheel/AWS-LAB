#!/bin/bash
# Install the CloudWatch agent and ship /var/log/fleet-health.log to lab7-fleet-health
set -euo pipefail
dnf install -y amazon-cloudwatch-agent
touch /var/log/fleet-health.log
cat > /opt/aws/amazon-cloudwatch-agent/etc/fleet-health.json <<'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          { "file_path": "/var/log/fleet-health.log",
            "log_group_name": "lab7-fleet-health",
            "log_stream_name": "{instance_id}" }
        ]
      }
    }
  }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/fleet-health.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status
