#modules/s3-iam-module/output.tf

output "s3_role_arn" {
  value = aws_iam_role.s3_role.arn
}