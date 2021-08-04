variable "availability_zones" {
  type        = list(string)
  description = "If this variable is not specified, then by default, subnets will be created in each availability zone"
}

variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "private_subnet_names" {
  type = list(string)
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "public_subnet_names" {
  type = list(string)
}

variable "public_subnet_tags" {
  description = "A map of tags to add to public subnets"
  type        = map(string)
}

variable "private_subnet_tags" {
  description = "A map of tags to add to private subnets"
  type        = map(string)
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

variable "vpc_cidr" {
}

variable "vpc_tags" {
  description = "A map of tags to add to vpc"
  type        = map(string)
}

locals {
  prefix = var.app_name
  common_tags = {
    "tr:environment-type" = var.tr_environment_type
    "tr:resource-owner"   = var.tr_resource_owner
  }
}
