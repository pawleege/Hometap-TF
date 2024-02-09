#output.tf
output "s3_role_arn" {
  value = module.s3_iam_module.s3_role_arn
}