#modules/s3-iam-module/output.tf

output "s3_profile_arn" {
  value = aws_iam_instance_profile.s3_profile.arn
}