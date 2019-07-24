resource "aws_default_vpc" "cloud9devenv_vpc" {

  tags = {
    Name = "Cloud9DevEnv Default VPC"
  }
}

resource "aws_subnet" "cloud9devenv_sub" {
  vpc_id = "${aws_default_vpc.cloud9devenv_vpc.id}"
  availability_zone = "${var.aws_region}a"

  cidr_block = "172.31.0.0/24"

  tags = {
    Description = "Cloud9DevEnv subnet for ${var.aws_region}a"
  }
}

locals {
  subnet_id = "${aws_subnet.cloud9devenv_sub.id}"
}

#data "aws_canonical_user_id" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloud9_environment_ec2" "default" {
  name                        = "${var.name}"
  instance_type               = "${var.instance_type}"
  automatic_stop_time_minutes = "${var.automatic_stop_time_minutes}"
  description                 = "${var.description}"
  subnet_id                   = "${local.subnet_id}"
  #owner_arn                   = "${data.aws_canonical_user_id.current.id}"
  owner_arn                   = "${data.aws_caller_identity.current.arn}"
}

