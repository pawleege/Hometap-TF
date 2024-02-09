#modules/s3-logging-bucket/var.tf

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}