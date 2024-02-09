#modules/s3-logging-bucket/outputs.tf

output "log_bucket" {
  value = aws_s3_bucket.log_bucket.id
}