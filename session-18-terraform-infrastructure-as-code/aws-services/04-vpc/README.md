# 🌐 AWS VPC (Virtual Private Cloud) — Isolated Cloud Networking

## 📌 1. What is Amazon VPC?
**Amazon Virtual Private Cloud (Amazon VPC)** enables organizations to provision a logically isolated section of the AWS Cloud where AWS resources (such as EC2, RDS, and ECS) can be launched in a custom virtual network.

VPC gives full control over the virtual networking environment, including selection of IP address ranges, creation of subnets, and configuration of route tables and network gateways.

---

## 🏗️ 2. Core VPC Networking Components

```
+-----------------------------------------------------------------------------------+
|                        AMAZON VPC (CIDR: 10.0.0.0/16)                             |
|                                                                                   |
|  +-------------------------------------+   +------------------------------------+ |
|  |     PUBLIC SUBNET (10.0.1.0/24)     |   |    PRIVATE SUBNET (10.0.2.0/24)    | |
|  |                                     |   |                                    | |
|  |  [ Internet Gateway (IGW) ] <----+  |   |  [ Application Server (EC2) ]      | |
|  |                                  |  |   |                │                   | |
|  |  [ NAT Gateway (10.0.1.50) ] <---┼--+---+----------------+                   | |
|  |  (Has Elastic IP attached)       |  |                                        | |
|  |                                  |  |   +------------------------------------+ |
|  |  [ Bastion / Jump Server (EC2) ] │  |   |   DATABASE SUBNET (10.0.3.0/24)    | |
|  +----------------------------------+--+   |                                    | |
|                                     │      |  [ Amazon RDS Multi-AZ ]           | |
|                                     ▼      |  (Completely Isolated from Internet)|
|                             [ INTERNET ]   +------------------------------------+ |
+-----------------------------------------------------------------------------------+
```

### A. CIDR Block (Classless Inter-Domain Routing)
- Defines the total contiguous IPv4 address space allocated to the VPC.
- Example: `10.0.0.0/16` provides $2^{16} = 65,536$ total private IP addresses.
- **AWS Reserved IPs**: In every subnet, AWS reserves 5 IP addresses (Network Address `.0`, VPC Router `.1`, DNS Server `.2`, Future Use `.3`, and Broadcast Address `.255`).

### B. Subnets (Public vs Private)
- Subnets segment the VPC CIDR across specific Availability Zones:
  - **Public Subnet**: Route table contains an explicit route target to the **Internet Gateway (`0.0.0.0/0 -> igw-xxxx`)**. Instances can receive public IPv4 addresses and communicate directly with the Internet.
  - **Private Subnet**: Route table routes outbound internet traffic through a **NAT Gateway (`0.0.0.0/0 -> nat-xxxx`)** located in a public subnet. External traffic cannot initiate inbound connections.
  - **Isolated Subnet**: Has no route to IGW or NAT; strictly internal for database layers (RDS).

### C. Route Tables
- A set of rules (called routes) that determine where network traffic from subnets is directed.
- Each subnet must be associated with exactly one route table.

### D. Internet Gateway (IGW) vs NAT Gateway
- **Internet Gateway (IGW)**: A horizontally scaled, redundant, highly available VPC component that enables two-way communication between instances in public subnets and the internet.
- **NAT Gateway (Network Address Translation)**: Enables instances in a private subnet to connect to the internet (e.g., for software updates or OS patches) while preventing external hosts from initiating connections to those instances. Requires an **Elastic IP (EIP)**.

### E. Security Groups vs Network ACLs (NACLs)

| Feature | Security Group (SG) | Network ACL (NACL) |
|---|---|---|
| **Scope** | Instance Level (EC2, RDS, ENI) | Subnet Level |
| **State** | **Stateful** (Return traffic is automatically allowed) | **Stateless** (Inbound and outbound rules must be defined explicitly) |
| **Rules Support** | Allow rules only | **Allow and Deny** rules |
| **Rule Evaluation**| All rules are evaluated simultaneously | Evaluated in sequential numerical order (e.g., 100, 200) |

---

## 🛡️ 3. Multi-Tier Production Architecture Best Practice

```
Tier 1 (Public Subnet):     Application Load Balancer (ALB) + NAT Gateway + Bastion Host
                                     │ (Traffic routed on Port 80/443)
                                     ▼
Tier 2 (Private App Subnet): Auto-Scaling Group of EC2 App Instances / EKS Nodes
                                     │ (Internal DB connections only)
                                     ▼
Tier 3 (Isolated DB Subnet): Amazon RDS Multi-AZ Database Cluster (No Internet Access)
```

---

## 💼 4. Common Real-World Use Cases

1. **Secure 3-Tier Enterprise Web Applications**: Strict network boundary isolation between presentation, application, and database tiers.
2. **Hybrid Cloud Connectivity**: Connecting corporate on-premises datacenters to AWS via **AWS Site-to-Site VPN** or dedicated low-latency **AWS Direct Connect**.
3. **VPC Peering & Transit Gateway**: Interconnecting multiple VPCs across different accounts and regions with centralized routing.
4. **Private Endpoint Integration (AWS PrivateLink / VPC Endpoints)**: Accessing S3 and DynamoDB from private subnets without traversing the public internet.
