provider "aws" {
  region = var.region
}

variable "region" {
}

terraform {
  backend "s3" {
  }
  required_version = ">= 0.12"
}