#main.tf
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["C:/Users/nerd6/.aws/credentials"]
}

#Setup S3 bucket for logging
module "s3_logging_bucket" {
  source = "./modules/s3-logging-bucket"
  bucket_name = local.bucket_name
}

#Setup S3 bucket with logging (using bucket above) & versioning
#Also Setup iam role and policy for S3 bucket
module "s3_iam_module" {
  source = "./modules/s3-iam-module"
  bucket_name = local.bucket_name
  log_bucket = module.s3_logging_bucket.log_bucket
  role_name = local.role_name
}

#Setup Autoscaling group and 
module "webserver_cluster" {
  source = "./modules/webserver-cluster"
  cluster_name = local.cluster_name

  image_id = local.image_id
  instance_type = local.instance_type
  min_size = local.min_size
  max_size = local.max_size
  
  s3_role_arn = module.s3_iam_module.s3_role_arn
}
