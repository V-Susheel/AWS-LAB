# Lab 5 – S3 + CloudWatch

## Part A: S3 (bucket sv-lab-955)
- Enabled versioning; uploaded notes.txt twice, deleted it, saw the delete marker,
  then restored the file by removing the marker — like Azure blob versioning
- Lifecycle rule `lab-lifecycle`: Standard → Standard-IA after 30 days →
  Glacier Flexible Retrieval after 90 days; noncurrent versions deleted after 30 days
- Presigned URL: the object URL returned AccessDenied (bucket is private);
  a 5-minute presigned URL worked, then expired — like an Azure SAS token

## S3 storage classes (my summary)
| Class | When to use |
|---|---|
| Standard | Frequently accessed |
| Intelligent-Tiering | Unknown or changing access; AWS moves data automatically |
| Standard-IA | Accessed about monthly, needs instant access |
| One Zone-IA | Like Standard-IA, re-creatable data, one AZ only |
| Glacier Instant Retrieval | Rarely read archive, millisecond access |
| Glacier Flexible Retrieval | Archive, minutes to hours to retrieve |
| Glacier Deep Archive | Cheapest, 12+ hours to retrieve (compliance) |

## Part B: CloudWatch (instance lab-monitor-1)
- Added CloudWatchAgentServerPolicy to lab-ec2-ssm-role
- Alarm `lab-high-cpu` (CPU > 50%) → SNS topic `lab-alerts` → email;
  triggered it with stress-ng and received the alert —
  like an Azure Monitor alert + action group
  <img width="748" height="277" alt="image" src="https://github.com/user-attachments/assets/af1f5e67-f88d-42cf-bb43-1dcd82394024" />
  <img width="457" height="202" alt="image" src="https://github.com/user-attachments/assets/347270da-3f28-4424-a6e2-17717b227ef6" />
- Installed the CloudWatch agent and shipped the nginx access log to log group
  `lab-nginx-access` — like the Azure Monitor Agent sending to Log Analytics
- Logs Insights query: `stats count(*) as requests by bin(1m)`
  (KQL version: `summarize count() by bin(TimeGenerated, 1m)`)

## Troubleshooting
- stress-ng aborted with "temp-path '.' must be readable and writeable":
  Session Manager logs in as ssm-user in `/`, which isn't writable. Fixed with `cd /tmp`.

## Cleanup
- Terminated lab-monitor-1; deleted the alarm, log group and SNS topic; kept the bucket
