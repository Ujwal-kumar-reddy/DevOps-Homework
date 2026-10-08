# 🔐 AWS IAM (Identity and Access Management) — Governance & Security

## 📌 1. What is AWS IAM?
**AWS Identity and Access Management (IAM)** is a foundational AWS security service that allows administrators to securely manage access to AWS services and resources. IAM provides centralized control over authentication (who can sign in) and authorization (what permissions they have).

IAM is **global** — users, groups, roles, and policies apply across all AWS regions automatically without needing regional replication.

---

## 👥 2. Core IAM Entities & Concepts

```
+-----------------------------------------------------------------------------------+
|                                 IAM HIERARCHY                                     |
+-----------------------------------------------------------------------------------+
|  AWS Root Account (Full Administrative Authority - Secure with MFA)               |
|   │                                                                               |
|   ├── IAM Groups (e.g., DevOps-Team, Developers, Auditors)                        |
|   │     └── IAM Users (Individual human identities with credentials)              |
|   │           └── Attached Policies (JSON permission documents)                   |
|   │                                                                               |
|   └── IAM Roles (Assumable identities for EC2, Lambda, GitHub Actions, STS)       |
|         └── Attached Policies & Trust Relationship Policy                         |
+-----------------------------------------------------------------------------------+
```

### A. IAM Users
- Represents an individual person or service requiring interactive or programmatic access to AWS.
- Credential types:
  - **Console Password**: For logging into the AWS Management Console (must enforce MFA).
  - **Access Key ID & Secret Access Key**: For AWS CLI, SDK, and API automation.

### B. IAM Groups
- A collection of IAM users.
- Permissions attached to a group are automatically inherited by all members within that group.
- Simplifies access management (e.g., adding a new engineer to the `Developers` group grants standard permissions instantly).
- Groups cannot contain other groups (no nesting).

### C. IAM Roles
- An identity with permission policies that determine what the identity can and cannot do in AWS.
- Unlike users, roles **do not have permanent passwords or access keys**.
- Roles are **assumed temporarily** by:
  - AWS Services (e.g., an EC2 instance or Lambda function accessing S3).
  - Federated users (Single Sign-On / SAML 2.0 / OpenID Connect).
  - Cross-account access (allowing User in Account A to manage resources in Account B).
  - CI/CD Pipelines (e.g., GitHub Actions assuming an IAM role via OIDC token).

### D. IAM Policies
- JSON documents that explicitly define allowed or denied actions on specified AWS resources.
- Types of Policies:
  1. **AWS Managed Policies**: Maintained and updated by AWS (e.g., `AmazonS3ReadOnlyAccess`, `AdministratorAccess`).
  2. **Customer Managed Policies**: Created and customized by your organization with fine-grained controls.
  3. **Inline Policies**: Embedded directly inside a single user, group, or role.

---

## 📜 3. IAM Policy Anatomy (JSON Structure)

Every IAM policy statement contains 5 core elements:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ObjectReadForDevOps",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::devops-homework-bucket-2026",
        "arn:aws:s3:::devops-homework-bucket-2026/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        },
        "IpAddress": {
          "aws:SourceIp": "203.0.113.0/24"
        }
      }
    }
  ]
}
```

- **Effect**: `Allow` or `Deny` (Explicit `Deny` always overrides any `Allow`).
- **Action**: The specific API operations permitted (e.g., `s3:GetObject`, `ec2:DescribeInstances`).
- **Resource**: The target resource ARN (`arn:aws:s3:::bucket-name/*`).
- **Condition**: Optional constraints (e.g., requiring HTTPS `aws:SecureTransport`, enforcing MFA, or restricting by IP CIDR).

---

## 🎯 4. Principle of Least Privilege & Permission Boundaries

```
                 +---------------------------+
                 |    IAM Identity Policy    |  (What the user asks for)
                 +-------------+-------------+
                               |
                               v
                       [ INTERSECTION ]  <==== EFFECTIVE PERMISSION
                               ^
                               |
                 +-------------+-------------+
                 |   Permissions Boundary    |  (Maximum allowable ceiling)
                 +---------------------------+
```

- **Principle of Least Privilege (PoLP)**: Users and services must only be granted the minimum permissions necessary to perform their assigned task.
- **Permission Boundaries**: Advanced IAM feature using managed policies to set the maximum allowable permissions an identity policy can grant. Even if a developer attaches `AdministratorAccess`, the boundary restricts what actions can actually execute.

---

## 🛡️ 5. IAM Security Best Practices

1. **Lock Down the AWS Root User**:
   - Use the root account solely for initial account setup and billing.
   - Attach hardware or FIDO2 Multi-Factor Authentication (MFA).
   - Delete all root access keys.
2. **Enforce MFA for All Users**:
   - Require virtual (Authenticator apps) or hardware MFA for every console user.
3. **Use IAM Roles Instead of Long-Lived Access Keys**:
   - Attach IAM Instance Profiles to EC2 instances.
   - Use GitHub Actions OIDC federation instead of storing hardcoded AWS credentials in secrets.
4. **Regular Credential Rotation**:
   - Rotate any existing access keys every 90 days.
5. **Implement Strong Password Policies**:
   - Minimum 14 characters, uppercase, lowercase, numbers, symbols, and automatic expiration.
6. **Use AWS IAM Access Analyzer**:
   - Continuously evaluate resource policies to identify unintended external or cross-account access.

---

## 💼 6. Real-World Use Cases

| Scenario | Recommended IAM Solution |
|---|---|
| **EC2 Web Server accessing S3 assets** | Attach an IAM Role to the EC2 Instance Profile with `s3:GetObject` permission. No credentials stored on disk. |
| **CI/CD Deployment from GitHub Actions** | Configure AWS IAM OpenID Connect (OIDC) identity provider. Pipeline exchanges short-lived JWT token for temporary STS credentials. |
| **Multi-Tier Organization Access** | Group users into `DevTeam`, `QATeam`, and `OpsTeam`. Grant `PowerUserAccess` to dev accounts and read-only to production accounts. |
| **Cross-Account Resource Administration** | Production Account trusts an IAM Role in Management Account. Ops engineer uses `sts:AssumeRole` to perform maintenance. |
