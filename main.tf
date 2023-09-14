data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  tags = {
    Automation  = "true"
    Environment = var.environment
  }
}

module "db" {
  source                           = "terraform-aws-modules/rds/aws"
  version                          = "6.1.0"
  identifier                       = format("%s-%s", var.environment, var.name)
  db_name                          = var.db_name
  port                             = var.port
  engine                           = var.engine
  username                         = var.master_username
  password                         = var.manage_master_user_password ? null : random_password.master[0].result
  multi_az                         = var.multi_az
  subnet_ids                       = var.subnet_ids
  kms_key_id                       = var.kms_key_arn
  instance_class                   = var.instance_class
  storage_type = var.storage_type
  engine_version                   = var.engine_version
  allocated_storage                = var.allocated_storage
  storage_encrypted                = var.storage_encrypted
  max_allocated_storage = var.enable_storage_autoscaling && var.max_allocated_storage != ""? var.max_allocated_storage : null
  publicly_accessible              = var.publicly_accessible
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_db_subnet_group           = var.create_db_subnet_group
  replicate_source_db              = var.replicate_source_db
  vpc_security_group_ids           = split(",", module.security_group_rds.security_group_id)
  skip_final_snapshot              = var.skip_final_snapshot
  snapshot_identifier              = var.snapshot_identifier
  maintenance_window               = var.maintenance_window
  backup_window                    = var.backup_window
  apply_immediately                = var.apply_immediately
  backup_retention_period          = var.backup_retention_period
  manage_master_user_password      = var.manage_master_user_password ? true : false
  # random_password_length                 = var.random_password_length
  # create_random_password                 = var.create_random_password
  monitoring_interval              = "30"
  monitoring_role_name             = format("%s-%s-RDSPostgresql", var.name, var.environment)
  create_monitoring_role           = true
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  enabled_cloudwatch_logs_exports  = ["postgresql"]
  tags = merge(
    { "Name" = format("%s-%s", var.environment, var.name) },
    local.tags,
  )

  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.deletion_protection
}

module "db_replica" {
  source                           = "terraform-aws-modules/rds/aws"
  version                          = "6.1.0"
  count = var.replica_enable ? var.replica_count : 0
  identifier                       = format("%s-%s-%s", var.environment, var.name, "replica")
  port                             = var.port
  engine                           = var.engine
  multi_az                         = var.multi_az
  kms_key_id                       = var.kms_key_arn
  instance_class                   = var.instance_class
  storage_type = var.storage_type
  engine_version                   = var.engine_version
  storage_encrypted                = var.storage_encrypted
  publicly_accessible              = var.publicly_accessible
  replicate_source_db              = module.db.db_instance_identifier
  vpc_security_group_ids           = split(",", module.security_group_rds.security_group_id)
  skip_final_snapshot              = var.skip_final_snapshot
  snapshot_identifier              = var.snapshot_identifier
  maintenance_window               = var.maintenance_window
  backup_window                    = var.backup_window
  apply_immediately                = var.apply_immediately
  backup_retention_period          = var.backup_retention_period
  monitoring_interval              = "30"
  monitoring_role_arn                   = module.db.enhanced_monitoring_iam_role_arn
  create_monitoring_role           = false
  create_cloudwatch_log_group            = false
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  enabled_cloudwatch_logs_exports  = ["postgresql"]
  tags = merge(
    { "Name" = format("%s-%s", var.environment, var.name) },
    local.tags,
  )

  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.deletion_protection
  depends_on = [ module.db ]
}

resource "aws_security_group_rule" "default_ingress" {
  count = var.create_security_group && length(var.allowed_security_groups) > 0 ? 1 : 0

  description = "From allowed SGs"

  type                     = "ingress"
  to_port                  = var.port
  from_port                = var.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = module.security_group_rds.security_group_id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count = var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description = "From allowed CIDRs"

  type              = "ingress"
  to_port           = var.port
  from_port         = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = module.security_group_rds.security_group_id
}

module "security_group_rds" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  name        = format("%s-%s-%s", var.environment, var.name, "rds-sg")
  create      = var.create_security_group
  vpc_id      = var.vpc_id
  description = "Complete PostgreSQL example security group"

  egress_with_cidr_blocks = [
    {
      to_port     = 0
      from_port   = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "rds-sg") },
    local.tags,
  )
}

resource "aws_secretsmanager_secret" "secret_master_db" {
  name = format("%s/%s/%s", var.environment, var.name, "rds-postgresql-pass")
  tags = merge(
    { "Name" = format("%s/%s/%s", var.environment, var.name, "rds-mysql-pass") },
    local.tags,
  )
}

resource "random_password" "master"{
  count = var.manage_master_user_password ? 0 : 1
  length           = var.random_password_length
  special          = false
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  count = var.manage_master_user_password ? 0 : 1
  secret_id     = aws_secretsmanager_secret.secret_master_db.id
  secret_string = <<EOF
{
  "username": "${module.db.db_instance_username}",
  "password": "${random_password.master[0].result}",
  "engine": "${var.engine}",
  "host": "${module.db.db_instance_endpoint}"
}
EOF
}