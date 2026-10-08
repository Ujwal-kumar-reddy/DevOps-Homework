# 💻 AWS EC2 (Elastic Compute Cloud) — Virtual Server Infrastructure

## 📌 1. What is Amazon EC2?
**Amazon Elastic Compute Cloud (Amazon EC2)** is a core AWS service that provides scalable virtual computing capacity in the cloud. It eliminates the need to invest in upfront hardware, allowing organizations to launch, scale, configure, and terminate virtual servers (called **EC2 instances**) within minutes.

EC2 offers complete control over instance operating systems, software stacks, network placement, and security perimeters.

---

## 🏗️ 2. Core EC2 Building Blocks

```
+-----------------------------------------------------------------------------------+
|                            AMAZON EC2 ARCHITECTURE                                |
+-----------------------------------------------------------------------------------+
|  AMI (Amazon Machine Image - OS & Software Template)                              |
|   │                                                                               |
|   ├── Instance Type (CPU, Memory, Storage, Network Bandwidth)                     |
|   │                                                                               |
|   ├── Storage: EBS Volumes (Persistent root & data drives) / Instance Store       |
|   │                                                                               |
|   ├── Network: VPC Subnet, Public/Private IP, Elastic IP (Static IPv4)            |
|   │                                                                               |
|   └── Security: Key Pair (SSH/RDP) & Security Groups (Virtual Firewall)           |
+-----------------------------------------------------------------------------------+
```

### A. AMI (Amazon Machine Image)
An AMI is a pre-configured template providing the OS, application server, and initial configurations:
1. **AWS Quick Start AMIs**: Maintained by AWS (Amazon Linux 2023, Ubuntu 24.04, RHEL, Windows Server).
2. **Custom AMIs (Golden Images)**: Built using tools like HashiCorp Packer or EC2 Image Builder with pre-installed organization security agents and dependencies.
3. **AWS Marketplace AMIs**: Hardened vendor images (e.g., CIS Benchmarks, Fortinet Firewall, Datadog agents).
4. **Community AMIs**: Publicly shared templates by the open-source community.

### B. Instance Types & Families
AWS categorizes instance types by hardware optimization:

| Family | Prefix | Optimization | Ideal Workload | Example Types |
|---|---|---|---|---|
| **General Purpose** | `t4g`, `m6i`, `m7g` | Balanced CPU/RAM | Web servers, dev environments, microservices | `t4g.micro`, `m6i.large` |
| **Compute Optimized** | `c6i`, `c7g` | High CPU-to-memory ratio | Batch processing, video encoding, gaming servers | `c7g.xlarge` |
| **Memory Optimized** | `r6i`, `r7g`, `x2gd` | High RAM-to-CPU ratio | In-memory caches (Redis/Memcached), high-performance DBs | `r6i.2xlarge` |
| **Storage Optimized** | `i3en`, `d3`, `d3en` | Low-latency NVMe / massive storage | Data warehousing, distributed filesystems (Cassandra/Kafka) | `i3en.xlarge` |
| **Accelerated Computing**| `p4de`, `g5` | GPU / TPU hardware acceleration | Machine learning training, AI inference, 3D rendering | `g5.xlarge`, `p4de.24xlarge` |

### C. Key Pairs
- Public key cryptography is used to authenticate secure shell access without transmitting plaintext passwords.
- **Linux Instances**: SSH access using the private key (`ssh -i key.pem ec2-user@<public-ip>`).
- **Windows Instances**: Private key decrypts the generated local Administrator password for Remote Desktop Protocol (RDP).

### D. Security Groups
- Act as a **stateful virtual firewall** controlling inbound and outbound traffic at the instance level.
- **Stateful Rule**: If inbound traffic is allowed on port `443`, return outbound response traffic is automatically permitted regardless of outbound rules.
- Supports rules by Port, Protocol (TCP/UDP/ICMP), and Source/Destination (IPv4 CIDR, IPv6 CIDR, or reference to another Security Group ID).

### E. EBS (Elastic Block Store)
Network-attached persistent block storage for EC2 instances:
- **General Purpose SSD (`gp3`)**: Baseline 3,000 IOPS and 125 MB/s throughput; scale IOPS and throughput independently of storage capacity.
- **Provisioned IOPS SSD (`io2` / `io2 Block Express`)**: Sub-millisecond latency for mission-critical relational databases.
- **Throughput Optimized HDD (`st1`)**: Low-cost magnetic storage for big data, streaming workloads, and log processing.
- **Cold HDD (`sc1`)**: Lowest cost HDD storage for infrequently accessed sequential datasets.
- **EBS Snapshots**: Point-in-time incremental backups stored durably in Amazon S3.

### F. IP Addressing (Public, Private, & Elastic IPs)
- **Private IP**: Internal IP address assigned to every instance within the VPC subnet; persists through instance reboot and stop/start cycles.
- **Public IP**: Dynamically assigned from the Amazon public IP pool; **changes** whenever the instance is stopped and started.
- **Elastic IP (EIP)**: Static, persistent public IPv4 address allocated to your AWS account that can be dynamically remapped to any instance during failures.

---

## 🔄 3. EC2 Instance Lifecycle

```
[ Launch ]
    │
    ▼
[ Pending ] ──► (Preparing hardware & network)
    │
    ▼
[ Running ] ◄───────────────────────────┐
    │                                   │
    ├── (Reboot) ──► [ Running ]        │ (Start)
    │                                   │
    ├── (Stop)   ──► [ Stopping ] ──► [ Stopped ]
    │                                   │
    └── (Terminate) ─► [ Shutting-Down ] ──► [ Terminated ] (Gone)
```

---

## 💼 4. Common Real-World Use Cases

1. **Microservices & Web Hosting**: Auto-scaling groups of `t4g.small` or `m6i.large` instances behind an Application Load Balancer (ALB).
2. **Continuous Integration Runners**: Self-hosted GitHub Actions or GitLab runners spun up on demand.
3. **High-Performance Computing (HPC)**: Clustered compute-optimized instances connected via Elastic Fabric Adapter (EFA) for scientific simulation.
4. **Disaster Recovery**: Pre-configured AMIs and EBS snapshots ready to spin up compute in an alternate AWS region within minutes.
