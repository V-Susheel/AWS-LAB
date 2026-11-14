# Lab 6 – Cloud hardware: Arm vs x86, Nitro, host health

## What sits under an EC2 instance (AWS Nitro System)
- Thin Nitro hypervisor (built on KVM) → almost all host CPU goes to my instance
- Nitro cards offload work from the host CPU:
  - Network card → seen by the OS as ENA (Elastic Network Adapter)
  - Storage card → EBS volumes appear as local NVMe disks
  - Security chip → protects host integrity
- Azure equivalent: Azure Boost (MANA network adapter, storage offload)

## Instance naming
`m7g.xlarge` = m (general purpose) · 7 (generation) · g (Graviton) · xlarge (4 vCPU)
Azure equivalent: `Standard_D4ps_v6` = D (general) · 4 vCPU · p (Arm/Cobalt) · s (premium storage) · v6

## What I launched
| Name | Type | Architecture | CPU |
|---|---|---|---|
| lab-x86 | t3.micro | x86_64 | Intel Xeon |
| lab-arm | t4g.micro | arm64 (aarch64) | AWS Graviton2 |

## What the servers showed (screenshots in this folder)
- `lscpu`: x86_64 vs aarch64; hypervisor vendor KVM on both
- `lspci`: Elastic Network Adapter (ENA) + NVMe EBS Controller → the Nitro cards
- `lsblk`: disk is `nvme0n1`, not `sda`
- `nvme list`: model "Amazon Elastic Block Store" → network storage presented as local NVMe

## Benchmark (1 core, same commands on both)
| Instance | stress-ng bogo ops/s | sha256 (largest block) | Price/hour |
|---|---|---|---|
| t3.micro (x86) | 1758.02 | 392166.37k | $0.0075 |
| t4g.micro (Arm) | 43.41 | 1558883.53k | $0.0061 |

**Result:** <one sentence, e.g. "Graviton was X% slower/faster but Y% cheaper, so better price-performance">
**Limits:** burstable t-types on shared CPUs, 60-second test. Before migrating a real workload
to Arm, I'd benchmark the actual application and check that all its software supports arm64.

## Host health and maintenance
| Check | Whose problem | Fix |
|---|---|---|
| System status check | AWS hardware, network, power | Recover, or stop/start → moves to a new host (reboot doesn't) |
| Instance status check | My OS / config | Reboot, then troubleshoot inside the VM |

- Created alarm `lab-arm-auto-recover`: "Status check failed: system" → Recover action.
  Recovery keeps the same instance ID, private IP and EBS volumes. (Azure: service healing)
- "Either" can't use Recover, because moving hardware doesn't fix an OS problem
- Scheduled maintenance: EC2 → Events (console), and from inside the VM via IMDS
  `/latest/meta-data/events/maintenance/scheduled` → returned `[]` (nothing scheduled)
  Azure equivalent: Scheduled Events in Azure IMDS (same 169.254.169.254 address)

## GPU capacity
- Quotas are in vCPUs and often start at 0 → GPU capacity must be requested and planned ahead
- g5.xlarge = 1 NVIDIA A10G GPU (looked only, not launched)

## Instance catalog (CloudShell)
`aws ec2 describe-instance-types` comparing t3/t4g/m7i/m7g/c7g/g5 → screenshot: catalog-table.png
<img width="698" height="132" alt="image" src="https://github.com/user-attachments/assets/197ca9cb-dc6b-4f70-8f6a-7e9f88073702" />


## Cleanup
- Terminated lab-x86 and lab-arm; deleted the recover alarm
