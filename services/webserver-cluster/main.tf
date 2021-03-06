// same as the example code
resource "aws_launch_configuration" "example" {
  image_id        = "ami-40d28157"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

// same as the example code
// user_data = "{$file("user_data.sh")}"
data "template_file" "user_data" {
  // template = "${file("${path.module}/user-data-sh")}"
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}

// same as the example code
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

// same as the example code
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instnace"

  lifecycle {
    create_before_destroy = true
  }
}

// same as the example code
resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"
  from_port         = "${var.server_port}"
  to_port           = "${var.server_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

// same as the example code
data "aws_availability_zones" "all" {}

// same as the example code
resource "aws_elb" "example" {
  name               = "${var.cluster_name}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = "${var.server_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.server_port}/"
    interval            = 30
  }
}

// same as the example code
// added from chapter 4
resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"
}

// same as the example code
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.elb.id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

// same as the example code
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.elb.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

// same as the example code
data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "${var.db_remote_state_bucket}"
    key    = "${var.db_remote_state_key}"
    region = "us-east-1"
  }
}
