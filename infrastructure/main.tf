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
    Name = "Cloud9DevEnv subnet for ${var.aws_region}a"
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

# Search for matching instance: https://www.terraform.io/docs/providers/aws/d/instance.html
# Filters: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html
data "aws_instance" "Cloud9DevEnv" {
  instance_id = "i-050eced8129e019ad"

  # filter {
  #   name = "owner-id"
  #   values = ["${data.aws_caller_identity.current.id}"]
  # }

  # filter {
  #   name = "subnet-id"
  #   values = ["${local.subnet_id}"]
  # }

  # filter {
  #   name = "vpc-id"
  #   values = ["${aws_default_vpc.cloud9devenv_vpc.id}"]
  # }
}

resource "aws_ebs_volume" "Cloud9DevEnv" {
  availability_zone = "${var.aws_region}a"
  size              = "${var.volume_size}"

  tags = {
    Name = "Cloud9DevEnv EBS Volume for ${var.aws_region}a"
  }
}

# Mount the volumne: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
resource "aws_volume_attachment" "Cloud9DevEnv_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.Cloud9DevEnv.id}"
  instance_id = "${data.aws_instance.Cloud9DevEnv.instance_id}"
}

