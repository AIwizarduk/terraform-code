data "aws_caller_identity" "aws_account" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}  

resource "random_password" "db_password" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "${local.prefix}-rds-secret"
  description             = "RDS database secrets"
  recovery_window_in_days = 0
  tags                    = merge({ Name = "${local.prefix}-rds-secret" }, local.common_tags)
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({ "username" = var.rds_master_user, "password" = random_password.db_password.result })
}

resource "aws_security_group" "rds_instance_sg" {
  name        = "${local.prefix}-sg-${var.database_name}"
  description = "Security group for rds instance"
  vpc_id      = data.aws_vpc.selected.id

  # HTTPS API Gateway
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  # Database
  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  tags = merge({ Name = "${local.prefix}-sg-${var.database_name}" }, local.common_tags)
}

resource "aws_db_subnet_group" "rds-instance-subnet-group" {
  name        = "${local.prefix}-rds-dbsg"
  description = "Subnet Group for ${var.database_name} rds instance"
  subnet_ids  = var.private_subnet_ids
  tags        = merge({ Name = "${local.prefix}-rds-dbsg" }, local.common_tags)
}

resource "aws_db_instance" "rds-instance" {
  engine                    = var.rds_db_engine
  engine_version            = var.rds_db_engine_version
  identifier                = var.rds_instance
  instance_class            = var.rds_instance_class
  storage_type              = var.rds_storage_type
  allocated_storage         = var.rds_allocated_storage
  name                      = "${local.prefix}_${var.database_name}"
  vpc_security_group_ids    = [aws_security_group.rds_instance_sg.id]
  username                  = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]
  password                  = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]
  db_subnet_group_name      = aws_db_subnet_group.rds-instance-subnet-group.name
  multi_az                  = var.rds_enable_multiaz
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.prefix}-${var.database_name}-${formatdate("DD-MMM-YYYY", timestamp())}"
  tags                      = merge({ Name = "${local.prefix}-${var.database_name}" }, var.tags, local.common_tags)
}