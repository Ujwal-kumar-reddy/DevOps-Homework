# 🪣 Terraform AWS S3 Demo Project

A production-ready Terraform project provisioning an Amazon S3 bucket with enterprise security configurations:
- **S3 Versioning Enabled** (accidental deletion protection)
- **Server-Side Encryption Enabled** (`AES256` / SSE-S3)
- **Public Access Block Enabled** (BPA prevents accidental public exposure)
- **Environment & Project Resource Tagging**

---

## 📁 File Structure

```
terraform-s3-demo/
├── provider.tf        # Terraform & AWS provider configuration
├── variables.tf       # Configurable input variables (region, bucket name, env)
├── terraform.tfvars   # Variable definitions for development environment
├── main.tf            # S3 bucket, versioning, encryption, and access block resources
├── outputs.tf         # Exported bucket ARN, ID, region, and versioning state
└── README.md          # Project documentation
```

---

## 🚀 Terraform Workflow Execution

### 1. Initialize Working Directory
Downloads required provider plugins (`hashicorp/aws ~> 5.0`) and configures local state:
```bash
terraform init
```

### 2. Format Configuration Files
Ensures standard HCL code style and alignment:
```bash
terraform fmt
```

### 3. Validate Configuration Syntax
Performs static analysis to verify HCL syntax and internal consistency:
```bash
terraform validate
```

### 4. Generate Execution Plan
Previews the exact infrastructure additions and modifications prior to making changes:
```bash
terraform plan
```

### 5. Apply Changes to AWS
Provisions the S3 bucket and attached security resources:
```bash
terraform apply -auto-approve
```

### 6. Inspect State & Outputs
View managed state details and query defined outputs:
```bash
terraform show
terraform output
```

### 7. Clean Up & Destroy Resources
Gracefully teardown and destroy all provisioned infrastructure:
```bash
terraform destroy -auto-approve
```

---

## 🔒 Security Best Practices Implemented

1. **Explicit Server-Side Encryption**: Uses `aws_s3_bucket_server_side_encryption_configuration` to ensure all uploaded objects are encrypted at rest with `AES256`.
2. **Strict Public Access Block**: `aws_s3_bucket_public_access_block` enforces `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets`.
3. **Data Loss Prevention**: `aws_s3_bucket_versioning` ensures previous object revisions are retained.
4. **Standardized Metadata**: Consistent tagging enables automated cost allocation and compliance auditing.
