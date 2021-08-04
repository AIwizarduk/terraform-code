module "aws-vpc" {
  source                     = "./modules/aws-vpc"
  availability_zones         = var.availability_zones
  app_name                   = var.app_name
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_subnet_names       = var.private_subnet_names
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  public_subnet_names        = var.public_subnet_names
  public_subnet_tags         = var.public_subnet_tags
  private_subnet_tags        = var.private_subnet_tags
  tr_environment_type        = var.tr_environment_type
  tr_resource_owner          = var.tr_resource_owner
  vpc_cidr                   = var.vpc_cidr
  vpc_tags                   = var.vpc_tags
}

module "aws-rds" {
  source                = "./modules/aws-rds"
  app_name              = var.app_name
  database_name         = var.database_name
  private_subnet_ids    = module.aws-vpc.private_subnet_ids
  rds_allocated_storage = var.rds_allocated_storage
  rds_db_engine         = var.rds_db_engine
  rds_db_engine_version = var.rds_db_engine_version
  rds_enable_multiaz    = var.rds_enable_multiaz
  rds_instance          = var.rds_instance
  rds_instance_class    = var.rds_instance_class
  rds_master_user       = var.rds_master_user
  rds_storage_type      = var.rds_storage_type
  skip_final_snapshot   = var.skip_final_snapshot
  vpc_id                = module.aws-vpc.vpc_id
  tags                  = var.tags
  tr_environment_type   = var.tr_environment_type
  tr_resource_owner     = var.tr_resource_owner
}