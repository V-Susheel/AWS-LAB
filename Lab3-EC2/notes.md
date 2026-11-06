EC2 created with successful status check:
<img width="490" height="38" alt="image" src="https://github.com/user-attachments/assets/440b3627-8904-47ab-b6ba-178d78bdcf8a" />
Successfully connected to instance:
<img width="534" height="117" alt="image" src="https://github.com/user-attachments/assets/f5ebe602-73fe-46cb-9cb5-2066adcda83d" />
This is user data script:
#!/bin/bash
dnf install -y nginx
echo "<h1>Hello from lab-web-1 ($(hostname))</h1>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
Key points:
- AMI: the image the server is built from (I used Amazon Linux 2023) — like an Azure Marketplace image
- Instance type: the server size, t3.micro = 2 vCPU / 1 GiB — like an Azure VM size
- Security group: allow-only, stateful firewall on the network card; I allowed HTTP from my IP only — like an NSG
- EBS: the server's disk, 8 GiB gp3 — like an Azure Managed Disk
- User data: script that ran once at first boot to install nginx — like Custom Script Extension / cloud-init
- Session Manager: browser terminal through the IAM role, no SSH key or port 22 — like Azure Bastion
- IMDS: 169.254.169.254, where the server got its temporary role credentials — like Azure IMDS for Managed Identity
