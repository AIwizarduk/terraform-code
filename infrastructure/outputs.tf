output "vpc_id" {
  value = module.aws-vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.aws-vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value = module.aws-vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.aws-vpc.private_subnet_ids
}