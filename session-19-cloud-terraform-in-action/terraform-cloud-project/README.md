# ☁️ Terraform Cloud Architecture Project (Session 19)

A complete end-to-end cloud infrastructure project written in HashiCorp Terraform demonstrating:
- Custom VPC networking (`10.30.0.0/16`)
- Public Subnet with Internet Gateway & Route Tables
- Web Security Group with SSH, HTTP, and HTTPS ingress
- Auto-bootstrapped EC2 Web Server instance
- Hardened S3 Bucket with versioning, encryption, and public access blocks

---

## 📁 File Structure

```
terraform-cloud-project/
├── provider.tf        # Terraform requirements & AWS provider
├── variables.tf       # Parameter declarations (region, cidrs, instance type)
├── terraform.tfvars   # Variable values for production environment
├── main.tf            # All resource declarations (VPC, Subnet, IGW, SG, EC2, S3)
├── outputs.tf         # Exported network IDs, public IP, and URLs
└── README.md          # Project documentation
```

---

## 🚀 Step-by-Step Execution

```bash
# 1. Initialize directory & provider plugins
terraform init

# 2. Format & validate code
terraform fmt
terraform validate

# 3. Preview execution plan
terraform plan

# 4. Provision full cloud stack
terraform apply -auto-approve

# 5. View state & outputs
terraform show
terraform output

# 6. Teardown all resources
terraform destroy -auto-approve
```
