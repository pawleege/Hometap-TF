#var.tf
locals {
	bucket_name = "unique-bucket-name-ihopethisisdifferent"
	cluster_name = "example-cluster-name"
	image_id = "ami-0277155c3f0ab2930"
	instance_type = "t2.micro"
  min_size = 2
  max_size = 4
  role_name = "example-role"
}