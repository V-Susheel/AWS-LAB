# Lab 2 – VPC built by hand in the console
## What I built (and the Azure equivalent)
1. VPC `lab-vpc` 10.0.0.0/16 — like an Azure VNet address space
2. 4 subnets: public-a/private-a in us-east-2a, public-b/private-b in us-east-2b.
   Each AWS subnet lives in ONE Availability Zone (Azure subnets span all zones)
3. Internet gateway `lab-igw` attached to the VPC — Azure has no separate object;
   VNets get internet access built in
4. `public-rt`: 0.0.0.0/0 → internet gateway, associated with both public subnets
   (like an Azure route table / UDR)
5. `private-rt`: 0.0.0.0/0 → NAT gateway, associated with both private subnets
6. NAT gateway `lab-nat` in public-a with an Elastic IP — like Azure NAT Gateway,
   but in AWS you point a route at it instead of attaching it to the subnet

<img width="778" height="198" alt="image" src="https://github.com/user-attachments/assets/83e2f252-f453-4823-825d-81eb74ec76f4" />
## Key lessons
- A subnet is public ONLY because its route table sends 0.0.0.0/0 to an internet gateway
- NAT = outbound-only internet for private subnets; VPC-internal traffic uses the `local` route
- The main route table is auto-created; keep it private as a safe default

## Cleanup
- Deleted NAT gateway and released the Elastic IP (both cost money while they exist)
