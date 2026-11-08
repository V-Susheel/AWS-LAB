# Lab 4 – Auto Scaling group + Application Load Balancer

## What I built (and the Azure equivalent)
- Launch template 'lab-web-lt': AMI, instance type, security group, IAM profile and
  user data for every new server — like the VMSS model
- Target group `lab-web-tg`: list of servers + HTTP health check on `/` —
  like an Application Gateway backend pool + health probe
- Application Load Balancer `lab-alb`: internet-facing, across public-a and public-b —
  like Azure Application Gateway
- Auto Scaling group `lab-web-asg`: min 2 / desired 2 / max 4 across two AZs,
  CPU target-tracking at 50% — like VMSS with autoscale and automatic repairs
- Security groups: `lab-alb-sg` allows HTTP from my IP; `lab-web-sg` allows HTTP
  only from `lab-alb-sg` (security group as source — like Azure Application Security Groups)

## What I tested
- Refreshing the ALB DNS name showed different instance IDs and AZs → load balancing works
- Terminated one instance: the site stayed up, the ALB drained connections, and the
  ASG launched a replacement within seconds
  <img width="764" height="247" alt="image" src="https://github.com/user-attachments/assets/de00fc2a-523c-4ad4-b0d2-e4ec1d99e338" />


## Key lessons
- An ALB must span at least two Availability Zones
- With ELB health checks on, the ASG replaces servers the load balancer marks unhealthy
- Connection draining lets in-flight requests finish before a server is removed
- In production, servers belong in private subnets behind NAT; only the ALB is public

## Cleanup
- Deleted the ASG (terminates its instances), the ALB and the target group
- Kept the launch template, security groups and VPC (no cost)
