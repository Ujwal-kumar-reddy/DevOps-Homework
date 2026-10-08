output "vpc_id" {
  description = "The ID of the provisioned VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "security_group_id" {
  description = "The ID of the web security group"
  value       = aws_security_group.web_sg.id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 web server instance"
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "The public IPv4 address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_id" {
  description = "The name / ID of the S3 storage bucket"
  value       = aws_s3_bucket.app_storage.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 storage bucket"
  value       = aws_s3_bucket.app_storage.arn
}

output "web_application_url" {
  description = "HTTP access URL for the deployed web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}
