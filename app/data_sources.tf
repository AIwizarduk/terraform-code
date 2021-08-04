data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = var.tf_state_bucket_key
    region = var.region
  }
}

data "aws_vpc" "selected" {
  id = data.terraform_remote_state.network.outputs.vpc_id
}

data "aws_route53_zone" "route_53_zone" {
  name         = var.domain_name
  private_zone = false
}

## If you want to use your own AMI, please uncomment following code block and variables

# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = [var.ami_name]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = [var.ami_virtualization]
#   }
#   owners = [var.ami_owner]
# }

# Or amazon specified but latest

# data "aws_ami" "amazon_ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*-x86_64-gp2"]
#   }
# }