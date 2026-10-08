variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique name for the S3 bucket"
  default     = "devops-homework-s3-demo-2026"
}

variable "environment" {
  type        = string
  description = "Deployment environment tag"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "Project name tag"
  default     = "DevOps-Homework-Session18"
}
