# 🪣 AWS S3 (Simple Storage Service) — Cloud Object Storage

## 📌 1. What is Amazon S3?
**Amazon Simple Storage Service (Amazon S3)** is an industry-leading object storage service offering industry-standard scalability, data availability, security, and performance. S3 is designed for **99.999999999% (11 9's) durability** across multiple Availability Zones.

Unlike block storage (EBS) or file storage (EFS), S3 stores data as individual **objects** within containers called **buckets**.

---

## 🧱 2. Core Concepts: Buckets & Objects

```
+-----------------------------------------------------------------------------------+
|                              AMAZON S3 ARCHITECTURE                               |
+-----------------------------------------------------------------------------------+
|  S3 Bucket: devops-homework-s3-demo-2026 (Globally Unique Name, Bound to Region)   |
|   │                                                                               |
|   ├── Object: "app/config.json"                                                   |
|   │     ├── Key (File Path/Name): "app/config.json"                               |
|   │     ├── Value (Payload Data): Raw bytes (up to 5 TB per object)                |
|   │     ├── Version ID: "3/L4bqt3OMUSaKdTXvTr2PijiBL0"                            |
|   │     ├── Metadata: Content-Type, custom headers, x-amz-meta-*                  |
|   │     └── Access Control: Bucket Policies & Public Access Block                 |
|   │                                                                               |
|   └── Management Features: Versioning, Lifecycle Rules, Encryption, Logging       |
+-----------------------------------------------------------------------------------+
```

### Bucket Naming Rules
- Must be globally unique across all AWS accounts worldwide.
- Between 3 and 63 characters long.
- Contains only lowercase letters, numbers, hyphens (`-`), and dots (`.`).
- Cannot look like an IP address format (e.g., `192.168.5.4`).

---

## 🗄️ 3. S3 Storage Classes

| Storage Class | Durability | Availability | Retrieval Fee | Minimum Duration | Use Case |
|---|---|---|---|---|---|
| **S3 Standard** | 99.999999999% | 99.99% | None | None | Frequently accessed data, web assets, active databases |
| **S3 Intelligent-Tiering**| 99.999999999% | 99.9% | None | None | Unpredictable or changing access patterns (auto-moves data) |
| **S3 Standard-IA** | 99.999999999% | 99.9% | Per GB retrieved | 30 days | Infrequently accessed data, disaster recovery backups |
| **S3 One Zone-IA** | 99.999999999% (1 AZ)| 99.5% | Per GB retrieved | 30 days | Recreatable secondary backup data, non-critical copies |
| **S3 Glacier Instant** | 99.999999999% | 99.9% | Per GB retrieved (ms response) | 90 days | Long-term archives requiring immediate milliseconds retrieval |
| **S3 Glacier Flexible**| 99.999999999% | 99.9% | Per GB retrieved (mins to hours)| 90 days | Regulatory archives, tape replacements |
| **S3 Glacier Deep Archive**| 99.999999999% | 99.9% | Per GB retrieved (12-48 hours) | 180 days | Multi-year retention archives at lowest storage cost ($0.00099/GB) |

---

## 🛡️ 4. Versioning, Object Lock & Lifecycle Policies

### A. S3 Versioning
- Preserves, retrieves, and restores every version of every object stored in your bucket.
- **Accidental Deletion Protection**: Deleting an object places a *Delete Marker* without permanently destroying the underlying file.
- Combine with **MFA Delete** to require multi-factor token verification for permanent object deletion or bucket configuration updates.

### B. Lifecycle Policies
Automates transitions between storage classes to optimize cost over time:
```
[ Day 0: Object Uploaded ] ──► (S3 Standard)
         │
         ├── Day 30: Transition Rule ──► (S3 Standard-IA)
         │
         ├── Day 90: Transition Rule ──► (S3 Glacier Flexible Archive)
         │
         └── Day 365: Expiration Rule ─► [ Permanently Deleted ]
```

---

## 🔒 5. S3 Security & Encryption

1. **Server-Side Encryption (SSE)**:
   - **SSE-S3 (`AES256`)**: Encryption handled automatically using Amazon S3-managed keys at zero extra cost.
   - **SSE-KMS (`aws:kms`)**: Encryption using keys managed in AWS Key Management Service with audit trail logging in CloudTrail.
   - **SSE-C**: Customer-provided encryption keys sent along with each API call.
2. **Client-Side Encryption**: Encrypting plaintext bytes on the local host prior to sending them over HTTPS to S3.
3. **Block Public Access (BPA)**: Account-level and bucket-level centralized switches that override any ACLs or bucket policies that attempt to make data public.
4. **Bucket Policies**: JSON access control policies attached directly to the bucket enforcing TLS (`aws:SecureTransport`), IP restrictions, or cross-account sharing.

---

## 💼 6. Real-World Use Cases

1. **Static Website Hosting**: Hosting HTML, CSS, JavaScript, and images with ultra-low latency via Amazon CloudFront CDN.
2. **Data Lake Storage**: Central raw storage repository for Big Data analytics and query engines (AWS Athena, EMR, Redshift Spectrum).
3. **Automated Backup & Archive Repository**: Database backups and server snapshots retained cost-effectively via Glacier Deep Archive lifecycle rules.
4. **CI/CD Build Artifact Repository**: Storing compiled binaries, Docker image layers, and Terraform state files securely.
