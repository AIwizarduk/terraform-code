variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "database_name" {
  description = "Name of rds database"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs of private subnets"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes. If max_allocated_storage is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs"
}

variable "rds_db_engine" {
  description = "The database engine to use. For supported values, see the Engine parameter in API action CreateDBInstance. Note that for Amazon Aurora instances the engine must match the DB cluster's engine'.For information on the difference between the available Aurora MySQL engines see Comparison between Aurora MySQL 1 and Aurora MySQL 2 in the Amazon RDS User Guide"
}

variable "rds_db_engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10) and this attribute will ignore differences in the patch version automatically (e.g. 5.7.17). For supported values, see the EngineVersion parameter in API action CreateDBInstance. Note that for Amazon Aurora instances the engine version must match the DB cluster's engine version'"
}

variable "rds_enable_multiaz" {
  description = "Specifies if the RDS instance is multi-AZ"
}

variable "rds_instance" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
}

variable "rds_master_user" {
  description = "Username for the master DB user"
}

variable "rds_storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
}

variable "tags" {
  description = "A map of extra tags to add to rds"
  type        = map(string)
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

variable "vpc_id" {
  description = "ID of vpc in which resources will be created"
}

locals {
  prefix = var.app_name
  common_tags = {
    "tr:environment-type" = var.tr_environment_type
    "tr:resource-owner"   = var.tr_resource_owner
  }
}