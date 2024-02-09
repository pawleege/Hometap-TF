#modules/s3_iam_module/main.tf

# Create S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name = "${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log_bucket"

  tags = {
    Name = "${var.bucket_name}_log_bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "example_bucket" {
  bucket = aws_s3_bucket.example_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.example_bucket]

  bucket = aws_s3_bucket.example_bucket.id
  acl    = "private"
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

resource "aws_s3_bucket_logging" "example_bucket_logging" {
  bucket = aws_s3_bucket.example_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy for read/write access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject",
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/*",
          "arn:aws:s3:::${var.bucket_name}",
        ],
      },
    ],
  })
}

resource "aws_iam_role" "s3_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.s3_role.name
}