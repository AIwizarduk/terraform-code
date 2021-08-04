provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
  }
  required_version = ">= 0.12"
}