locals {
  region                  = "us-east-2"
  name                    = "postgresql"
  family                  = "postgres15"
  vpc_cidr                = "10.20.0.0/16"
  environment             = "prod"
  engine_version          = "15.2"
  instance_class          = "db.m5d.large"
  storage_type            = "gp3"
  multi_az_enabled        = false
  create_namespace        = true
  namespace               = "postgres"
  current_identity        = data.aws_caller_identity.current.arn
  allowed_security_groups = ["sg-0a680afd35"]
  custom_user_password    = ""
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
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
  enable_default_policy = true
  key_owners            = [local.current_identity]
  key_administrators    = [local.current_identity]
  key_users             = [local.current_identity]
  key_service_users     = [local.current_identity]
  key_statements = [
    {
      sid = "Allow use of the key"
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
          type = "Service"
          identifiers = [
            "monitoring.rds.amazonaws.com",
            "rds.amazonaws.com",
          ]
        }
      ]
    },
    {
      sid       = "Enable IAM User Permissions"
      actions   = ["kms:*"]
      resources = ["*"]

      principals = [
        {
          type = "AWS"
          identifiers = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn,
          ]
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${local.name}"]

  tags = local.additional_tags
}


module "vpc" {
  source                  = "squareops/vpc/aws"
  name                    = local.name
  vpc_cidr                = local.vpc_cidr
  environment             = local.environment
  availability_zones      = ["us-east-2a", "us-east-2b"]
  public_subnet_enabled   = true
  auto_assign_public_ip   = true
  intra_subnet_enabled    = false
  private_subnet_enabled  = true
  one_nat_gateway_per_az  = false
  database_subnet_enabled = true
}

module "rds-pg" {
  source                           = "squareops/rds-postgresql/aws"
  name                             = local.name
  db_name                          = "postgres"
  multi_az                         = local.multi_az_enabled
  family                           = local.family
  vpc_id                           = module.vpc.vpc_id
  subnet_ids                       = module.vpc.database_subnets ## db subnets
  environment                      = local.environment
  kms_key_arn                      = module.kms.key_arn
  storage_type                     = local.storage_type
  engine_version                   = local.engine_version
  instance_class                   = local.instance_class
  allowed_security_groups          = local.allowed_security_groups
  availability_zone                = local.multi_az_enabled ? null : "us-east-1a"
  master_username                  = "pguser"
  allocated_storage                = "20"
  max_allocated_storage            = 120
  publicly_accessible              = false
  skip_final_snapshot              = true
  backup_window                    = "03:00-06:00"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier_prefix = "final"
  major_engine_version             = local.engine_version
  deletion_protection              = false
  cloudwatch_metric_alarms_enabled = true
  alarm_cpu_threshold_percent      = 70
  disk_free_storage_space          = "10000000" # in bytes
  slack_notification_enabled       = false
  slack_username                   = "Admin"
  slack_channel                    = "postgresql-notification"
  slack_webhook_url                = "https://hooks/xxxxxxxx"
  custom_user_password             = local.custom_user_password
}


module "backup_restore" {
  depends_on                = [module.rds-pg]
  source                    = "../../modules/backup-restore"
  port                      = split(":", module.rds-pg.db_instance_endpoint)[1]
  create_namespace          = local.create_namespace
  namespace                 = local.namespace
  cluster_name              = "prod-eks"
  postgresql_backup_enabled = false
  bucket_provider_type      = "s3"
  postgres_backup_config = {
    db_username          = module.rds-pg.db_instance_username
    db_password          = module.rds-pg.db_instance_password
    s3_bucket_region     = "us-east-1"                
    cron_for_full_backup = "*/2 * * * *"               
    bucket_uri           = "s3://postgres-backup-file" 
    db_endpoint          = replace(module.rds-pg.db_instance_endpoint, ":5432", "")
  }

  postgres_restore_enabled = false
  postgres_restore_config = {
    db_endpoint      = replace(module.rds-pg.db_instance_endpoint, ":5432", "")
    db_port          = split(":", module.rds-pg.db_instance_endpoint)[1]
    db_username      = module.rds-pg.db_instance_username
    db_password      = module.rds-pg.db_instance_password
    bucket_uri       = "s3://postgres-backup-file/"
    s3_bucket_region = "us-east-1"           

  }
}
