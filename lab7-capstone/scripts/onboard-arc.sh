#!/bin/bash
# Onboard this EC2 instance to Azure Arc. All values come from SSM Parameter Store.
set -euo pipefail
REGION=us-east-2
p() { aws ssm get-parameter --region "$REGION" --name "/lab7/arc/$1" --with-decryption --query Parameter.Value --output text; }

if command -v azcmagent >/dev/null 2>&1 && azcmagent show | grep -q "Agent Status *: *Connected"; then
  echo "Already connected to Azure Arc"; exit 0
fi

TOKEN=$(curl -s -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
ARCH=$(uname -m | tr '_' '-')

curl -sSL -o /tmp/install_linux_azcmagent.sh https://gbl.his.arc.azure.com/azcmagent-linux
bash /tmp/install_linux_azcmagent.sh

azcmagent connect \
  --service-principal-id "$(p app-id)" \
  --service-principal-secret "$(p sp-secret)" \
  --tenant-id "$(p tenant-id)" \
  --subscription-id "$(p subscription-id)" \
  --resource-group "$(p resource-group)" \
  --location "$(p location)" \
  --cloud AzureCloud \
  --resource-name "lab7-${ARCH}-${INSTANCE_ID}" \
  --tags "Source=aws,Project=lab7-capstone,AwsInstanceId=${INSTANCE_ID}"

azcmagent show
