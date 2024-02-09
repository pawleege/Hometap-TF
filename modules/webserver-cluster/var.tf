# modules/webserver-cluster/var.tf
variable "s3_profile_arn" {
  description = "iam instance profile arn"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EC2 cluster"
  type        = string
}

variable "image_id" {
  description = "AMI image id for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to spin up"
  type        = string
}

variable "min_size" {
  description = "Min number of instances for scaling group"
  type        = number
}

variable "max_size" {
  description = "Max number of instances for scaling group"
  type        = number
}