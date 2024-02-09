# webserver_cluster/main.tf

# Get Available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a Security Group for an EC2 instance
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}


# Create a Security Group Rule, inbound http
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"
  
  from_port   = 80
  to_port   = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Create a Security Group Rule, inbound https
resource "aws_security_group_rule" "allow_https_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"
  
  from_port   = 443
  to_port   = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# Create a Security Group Rule, outbound all
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.instance.id}"
  
  from_port   = 0
  to_port   = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# Create a Launch Template
resource "aws_launch_template" "example_instance" {
  name_prefix   = "foobar"
  image_id      = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
}

# Create an Autoscaling Group
resource "aws_autoscaling_group" "example_service" {
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  health_check_type    = "EC2"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  service_linked_role_arn = module.s3_iam_module.s3_role_arn
  
  launch_template {
    id = "${aws_launch_template.example_instance.id}"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

# Create Autoscaling_Policy for scale_out
resource "aws_autoscaling_policy" "scale_out" {
  name = "${var.cluster_name}_asgpolicy_scaleout"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  scaling_adjustment_type = "PercentChangeInCapacity"
  policy_type        = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.example_service.name
  metric_aggregation_type = "Average"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70
  }
}

# Create Autoscaling_Policy for scale_in
resource "aws_autoscaling_policy" "scale_in" {
  name = "${var.cluster_name}_asgpolicy_scalein"
  scaling_adjustment = -1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  scaling_adjustment_type = "PercentChangeInCapacity"
  policy_type        = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.example_service.name
  metric_aggregation_type = "Average"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30
  }
}