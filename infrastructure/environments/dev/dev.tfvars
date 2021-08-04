############################################################################
# Common tfvars
############################################################################
region              = "eu-west-2"
app_name            = "talentegra"
tr_environment_type = "DEVELOPMENT"
tr_resource_owner   = "support@digitalq.co.in"

############################################################################
# VPC tfvars
############################################################################
availability_zones         = ["eu-west-2a", "eu-west-2b"]
public_subnet_cidr_blocks  = ["10.92.1.0/24", "10.92.2.0/24"]
private_subnet_cidr_blocks = ["10.92.3.0/24", "10.92.4.0/24"]
vpc_cidr                   = "10.92.0.0/16"

############################################################################
# RDS tfvars
############################################################################
database_name         = "talentegra"
rds_allocated_storage = "10"
rds_db_engine         = "mysql"
rds_db_engine_version = "8.0.23"
rds_enable_multiaz    = false
rds_instance          = "talentegra"
rds_instance_class    = "db.t3.micro"
rds_master_user       = "talentegra"
rds_storage_type      = "gp2"
skip_final_snapshot   = true