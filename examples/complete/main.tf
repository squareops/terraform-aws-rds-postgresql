locals {
  region         = "us-east-2"
  name           = "postgresql"
  vpc_id         = "vpc-06861ba817a8cda10"
  family         = "postgres15"
  subnet_ids     = ["subnet-09e8f6ea27b7e36d0","subnet-0b070110454617a90"]
  environment    = "prod"
  kms_key_arn    = ""
  engine_version = "15.2"
  instance_class = "db.m5d.large"
  allowed_security_groups = ["sg-0ef14212995d67a2d"]
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "rds-pg" {
  source                           = "squareops/rds-postgresql/aws"
  name                             = local.name
  db_name                          = "postgres"
  multi_az                         = "true"
  family                           = local.family
  vpc_id                           = local.vpc_id
  subnet_ids                       = local.subnet_ids ## db subnets
  environment                      = local.environment
  kms_key_arn                      = local.kms_key_arn
  engine_version                   = local.engine_version
  instance_class                   = local.instance_class
  master_username                  = "pguser"
  allocated_storage                = "20"
  publicly_accessible              = false
  skip_final_snapshot              = true
  backup_window                    = "03:00-06:00"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier_prefix = "final"
  allowed_security_groups          = local.allowed_security_groups
  major_engine_version             = local.engine_version
  deletion_protection              = false
  cloudwatch_metric_alarms_enabled = true
  alarm_cpu_threshold_percent      = 70
  disk_free_storage_space          = "10000000" # in bytes
  slack_username                   = ""
  slack_channel                    = ""
  slack_webhook_url                = ""
}
