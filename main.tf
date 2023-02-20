data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  tags = {
    Automation  = "true"
    Environment = var.environment
  }
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"
  identifier = format("%s-%s", var.environment, var.rds_instance_name)
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  storage_encrypted   = var.storage_encrypted
  kms_key_id          = var.kms_key_arn
  publicly_accessible = var.publicly_accessible
  replicate_source_db = var.replicate_source_db
  name                             = var.db_name
  username                         = var.master_username
  port                             = var.port
  multi_az                         = var.multi_az
  subnet_ids                       = var.subnet_ids
  vpc_security_group_ids           = split(",", module.security_group_rds.security_group_id)
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  snapshot_identifier              = var.snapshot_identifier
  maintenance_window               = var.maintenance_window
  backup_window                    = var.backup_window
  backup_retention_period          = var.backup_retention_period
  apply_immediately                = var.apply_immediately
  random_password_length           = var.random_password_length
  create_random_password           = var.create_random_password
  monitoring_interval             = "30"
  monitoring_role_name            = format("%s-%s-MyRDSMonitoringRole", var.rds_instance_name, var.environment)
  create_monitoring_role          = true
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(
    { "Name" = format("%s-%s", var.environment, var.rds_instance_name) },
    local.tags,
  )

  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.deletion_protection
}

resource "aws_security_group_rule" "default_ingress" {
  count = var.create_security_group && length(var.allowed_security_groups) > 0 ? 1 : 0

  description = "From allowed SGs"

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = module.security_group_rds.security_group_id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count = var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description = "From allowed CIDRs"

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = module.security_group_rds.security_group_id
}

module "security_group_rds" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  create      = var.create_security_group
  name        = format("%s-%s-%s", var.environment, var.rds_instance_name, "rds-sg")
  description = "Complete PostgreSQL example security group"
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.rds_instance_name, "rds-sg") },
    local.tags,
  )
}
