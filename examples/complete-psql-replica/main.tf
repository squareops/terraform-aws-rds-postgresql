locals {
  region      = "us-east-2"
  environment = "prod"
  name        = "postgresql"
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
  family   = "postgres15"
  vpc_cidr = "10.20.0.0/16"
  storage_type  = "gp3"
  engine_version = "15.2"
  current_identity = data.aws_caller_identity.current.arn
  allowed_security_groups = ["sg-0a680afd35"]
  instance_class = "db.m5d.large"
  replica_enable = true
  replica_count = 1
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  deletion_window_in_days = 7
  description             = "Complete key example showing various configurations available"
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  # Policy
  enable_default_policy                  = true
  key_owners                             = [local.current_identity]
  key_administrators                     = [local.current_identity]
  key_users                              = [local.current_identity]
  key_service_users                      = [local.current_identity]
  key_statements = [
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${local.name}"]

  tags = local.additional_tags
}


module "vpc" {
  source                = "squareops/vpc/aws"
  name                  = local.name
  vpc_cidr              = local.vpc_cidr
  environment           = local.environment
  availability_zones    = ["us-east-2a", "us-east-2b"]
  public_subnet_enabled = true
  auto_assign_public_ip = true
  intra_subnet_enabled                            = false
  private_subnet_enabled                          = true
  one_nat_gateway_per_az                          = false
  database_subnet_enabled                         = true
}

module "rds-pg" {
  source                           = "squareops/rds-postgresql/aws"
  name                             = local.name
  db_name                          = "postgres"
  family                           = local.family
  multi_az                         = "true"
  vpc_id                           = module.vpc.vpc_id
  subnet_ids                       = module.vpc.database_subnets ## db subnets
  environment                      = local.environment
  replica_enable                   = local.replica_enable
  replica_count                    = local.replica_count
  kms_key_arn                      = module.kms.key_arn
  storage_type                     = local.storage_type
  engine_version                   = local.engine_version
  instance_class                   = local.instance_class
  master_username                  = "pguser"
  allocated_storage                = "20"
  max_allocated_storage            = 120
  publicly_accessible              = false
  skip_final_snapshot              = true
  backup_window                    = "03:00-06:00"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier_prefix = "final"
  major_engine_version             = local.engine_version
  deletion_protection              = true
  cloudwatch_metric_alarms_enabled = true
  alarm_cpu_threshold_percent      = 70
  disk_free_storage_space          = "10000000" # in bytes
  slack_username                   = "Admin"
  slack_channel                    = "postgresql-notification"
  slack_webhook_url                = "https://hooks/xxxxxxxx"
}
