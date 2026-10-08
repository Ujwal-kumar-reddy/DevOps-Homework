output "bucket_id" {
  description = "The name / ID of the created S3 bucket"
  value       = aws_s3_bucket.demo_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.demo_bucket.arn
}

output "bucket_region" {
  description = "The AWS region where the bucket is created"
  value       = aws_s3_bucket.demo_bucket.region
}

output "versioning_status" {
  description = "The versioning state of the S3 bucket"
  value       = aws_s3_bucket_versioning.demo_versioning.versioning_configuration[0].status
}
