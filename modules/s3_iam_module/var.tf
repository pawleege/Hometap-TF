#modules/s3_iam_module/var.tf

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "role_name" {
  description = "The name of the iam role to access the S3 bucket"
  type        = string
}