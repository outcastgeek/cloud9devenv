# Multiple Regions: us-east-1 sa-east-1 eu-central-1 cn-north-1 ap-northeast-1 ap-southeast-2
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "name" {
  description = "The name of the environment"
  default = "Cloud9DevEnv"
}

variable "instance_type" {
  description = "The type of instance to connect to the environment"
  default     = "c5.2xlarge"
}

variable "automatic_stop_time_minutes" {
  description = "Minutes until the instance is shut down after inactivity"
  default     = 30
}

variable "description" {
  description = "The description of the environment"
  default = "Cloud9 DEV Environment"
}

