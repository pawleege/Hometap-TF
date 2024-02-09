provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["C:/Users/nerd6/.aws/credentials"]
}

module "s3_iam_module" {
  source = "./modules/s3-iam-module"
  bucket_name = local.bucket_name
  role_name = local.role_name
}

module "webserver_cluster" {
  source = "./modules/webserver-cluster"
  cluster_name = local.cluster_name
  image_id = local.image_id
  instance_type = local.instance_type
  min_size = local.min_size
  max_size = local.max_size
  s3_role_arn   = module.s3_iam_module.s3_role_arn

  depends_on = [module.s3_iam_module]
}
