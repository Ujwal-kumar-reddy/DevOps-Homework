# 🗄️ AWS Database Services — DynamoDB & Amazon RDS

A comparative architectural guide to AWS managed database services: **Amazon DynamoDB** (Serverless NoSQL) and **Amazon RDS** (Managed Relational Database Service).

---

## ⚡ 1. Amazon DynamoDB — Serverless NoSQL Database

```
+-----------------------------------------------------------------------------------+
|                            AMAZON DYNAMODB CONCEPTS                               |
+-----------------------------------------------------------------------------------+
|  Table: "CustomerOrders"                                                          |
|   │                                                                               |
|   ├── Item 1 (Row/Record):                                                        |
|   │     ├── Partition Key (PK - HASH): CustomerID = "CUST-1049"                   |
|   │     ├── Sort Key (SK - RANGE):      OrderTimestamp = "2026-10-08T18:30:00Z"   |
|   │     └── Attributes (Fields):        TotalAmount: $149.50, Status: "SHIPPED"   |
|   │                                                                               |
|   └── Item 2 (Can have completely different dynamic schema attributes!):          |
|         ├── Partition Key: CustomerID = "CUST-1049"                               |
|         ├── Sort Key:      OrderTimestamp = "2026-10-08T19:45:00Z"                |
|         └── Attributes:    TotalAmount: $89.00, LoyaltyPoints: 150, Items: [...]  |
+-----------------------------------------------------------------------------------+
```

### Core DynamoDB Concepts
1. **Tables, Items, & Attributes**:
   - **Table**: Collection of data items.
   - **Item**: A single record in the table (analogous to a row, up to 400 KB).
   - **Attribute**: A key-value data element (analogous to a field/column; schemaless except for the primary key).
2. **Primary Key Types**:
   - **Simple Primary Key (Partition Key only)**: Uses a single attribute (HASH) to distribute data across physical storage partitions uniformly.
   - **Composite Primary Key (Partition Key + Sort Key)**: Combines Partition Key (HASH) and Sort Key (RANGE). Enables rich query operations (`>`, `<`, `begins_with`, `between`) on items sharing the same partition key.
3. **Secondary Indexes**:
   - **Global Secondary Index (GSI)**: An index with a partition key and sort key that can be different from those on the base table. Can be created at any time.
   - **Local Secondary Index (LSI)**: An index that has the same partition key as the table, but a different sort key. Must be created during initial table creation.
4. **Capacity Modes**:
   - **On-Demand Mode**: Automatically scales up and down instantly to accommodate unpredictable traffic spikes; pay strictly per million read/write requests.
   - **Provisioned Mode**: Specify allocated Read Capacity Units (RCU) and Write Capacity Units (WCU) with optional Auto-Scaling for predictable, cost-optimized workloads.
5. **Key Features**:
   - Single-digit millisecond latency at any scale.
   - DynamoDB Streams (event-driven CDC triggers for AWS Lambda).
   - Point-in-Time Recovery (PITR) and Global Tables (multi-region active-active replication).

---

## 🐘 2. Amazon RDS — Relational Database Service

```
+-----------------------------------------------------------------------------------+
|                        AMAZON RDS MULTI-AZ ARCHITECTURE                           |
|                                                                                   |
|  [ Availability Zone 1 ]                   [ Availability Zone 2 ]                |
|  +---------------------------+             +---------------------------+          |
|  |   Primary DB Instance     | Synchronous |  Standby Replica Instance |          |
|  |   (Handles Reads & Writes)|=== Replicate ==> (Auto-Failover Target) |          |
|  +-------------+-------------+             +---------------------------+          |
|                │                                                                  |
|                │ Asynchronous Replication                                         |
|                ▼                                                                  |
|  +---------------------------+                                                    |
|  |     Read Replica 1        | (Offloads heavy read queries / BI reporting)       |
|  +---------------------------+                                                    |
+-----------------------------------------------------------------------------------+
```

### Supported Database Engines
1. **Amazon Aurora** (MySQL & PostgreSQL compatible, cloud-native, up to 5x faster than standard MySQL)
2. **PostgreSQL**
3. **MySQL**
4. **MariaDB**
5. **Oracle Database**
6. **Microsoft SQL Server**

### Key Management & Operational Features
1. **Automated Backups & PITR**:
   - Daily automated snapshots and continuous transaction log archiving (retention 1 to 35 days).
   - Restore database to any specific second within the retention window.
2. **Multi-AZ Deployments (High Availability)**:
   - Provisions a synchronous standby replica in a distinct Availability Zone.
   - During primary node failure, AWS automatically promotes the standby replica with zero data loss and updates the DB DNS endpoint.
3. **Read Replicas (Scalability)**:
   - Up to 15 read-only asynchronous replicas across availability zones or even separate AWS regions.
   - Directs read-heavy application traffic away from the write master node.
4. **Security & Governance**:
   - Network isolation within private database VPC subnets.
   - At-rest encryption using AWS KMS and in-transit encryption using SSL/TLS.
   - IAM Database Authentication (login without static database passwords).

---

## ⚖️ 3. DynamoDB vs Amazon RDS Comparison Matrix

| Feature | Amazon DynamoDB | Amazon RDS |
|---|---|---|
| **Data Model** | NoSQL (Key-Value / Document) | Relational (SQL Tables, Foreign Keys, Joins) |
| **Schema** | Schemaless / Flexible Attributes | Strict predefined schema |
| **Scaling** | Horizontal scaling (infinite throughput) | Vertical scaling (compute/RAM) + Read Replicas |
| **Latency** | Single-digit milliseconds ($1\text{--}5\text{ ms}$) | Low milliseconds ($5\text{--}20\text{ ms}$) |
| **Complex Queries** | Simple Key-Value / Filter lookups (No JOINs) | Full SQL complex JOINs, Aggregations, CTEs |
| **Transactions** | ACID transactions supported (`TransactWriteItems`) | Full native ACID transaction guarantees |
| **Management** | 100% Serverless (Zero OS or patch management) | Managed instances (automated patching & maintenance windows) |
| **Best For** | Mobile backends, gaming leaderboards, shopping carts | ERPs, CRM systems, financial ledgers, analytical reporting |
