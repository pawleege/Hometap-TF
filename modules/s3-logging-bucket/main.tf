#modules/s3-logging-bucket/main.tf

# Create S3 bucket for logging
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}_log_bucket"

  tags = {
    Name = "${var.bucket_name}_log_bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket]

  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}