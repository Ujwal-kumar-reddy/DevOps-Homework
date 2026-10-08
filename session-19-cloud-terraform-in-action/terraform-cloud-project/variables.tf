variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "production"
}

variable "project" {
  type        = string
  description = "Project name tag"
  default     = "Session19-Cloud-Terraform"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the custom VPC"
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.30.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "EC2 compute instance type"
  default     = "t3.micro"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique name for the S3 bucket"
  default     = "devops-session19-cloud-bucket-2026"
}
