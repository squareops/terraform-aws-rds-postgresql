locals {
  region                  = "us-east-1"
  name                    = "postgresql"
  family                  = "postgres15"
  vpc_cidr                = "10.20.0.0/16"
  environment             = "prod"
  create_namespace        = true
  namespace               = "pg"
  engine_version          = "15.4"
  instance_class          = "db.t4g.micro"
  storage_type            = "gp3"
  current_identity        = data.aws_caller_identity.current.arn
<<<<<<< Updated upstream
  allowed_security_groups = ["sg-xxxxxxxxxxxxxxxx"]
  custom_user_password    = ""
=======
  allowed_security_groups = ["sg-0c982318e4a801035"]
  custom_user_password    = "Amanrajj12"
>>>>>>> Stashed changes
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

<<<<<<< Updated upstream
module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "~> 1.0"
  deletion_window_in_days = 7
  description             = "Complete key example showing various configurations available"
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true
=======
# module "kms" {
#   source = "terraform-aws-modules/kms/aws"
#   version = "~> 1.0"
#   deletion_window_in_days = 7
#   description             = "Complete key example showing various configurations available"
#   enable_key_rotation     = true
#   is_enabled              = true
#   key_usage               = "ENCRYPT_DECRYPT"
#   multi_region            = true
>>>>>>> Stashed changes

#   # Policy
#   enable_default_policy = true
#   key_owners            = [local.current_identity]
#   key_administrators    = [local.current_identity]
#   key_users             = [local.current_identity]
#   key_service_users     = [local.current_identity]
#   key_statements = [
#     {
#       sid = "Allow use of the key"
#       actions = [
#         "kms:Encrypt*",
#         "kms:Decrypt*",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:Describe*"
#       ]
#       resources = ["*"]

#       principals = [
#         {
#           type = "Service"
#           identifiers = [
#             "monitoring.rds.amazonaws.com",
#             "rds.amazonaws.com",
#           ]
#         }
#       ]
#     },
#     {
#       sid       = "Enable IAM User Permissions"
#       actions   = ["kms:*"]
#       resources = ["*"]

#       principals = [
#         {
#           type = "AWS"
#           identifiers = [
#             "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
#             data.aws_caller_identity.current.arn,
#           ]
#         }
#       ]
#     }
#   ]

#   # Aliases
#   aliases = ["${local.name}"]

#   tags = local.additional_tags
# }


# module "vpc" {
#   source                  = "squareops/vpc/aws"
#   name                    = local.name
#   vpc_cidr                = local.vpc_cidr
#   environment             = local.environment
#   availability_zones      = ["us-east-2a", "us-east-2b"]
#   public_subnet_enabled   = true
#   auto_assign_public_ip   = true
#   intra_subnet_enabled    = false
#   private_subnet_enabled  = true
#   one_nat_gateway_per_az  = false
#   database_subnet_enabled = true
# }

module "rds-pg" {
<<<<<<< Updated upstream
  source                           = "squareops/rds-postgresql/aws"
  name                             = local.name
  db_name                          = "test"
  multi_az                         = "true"
  family                           = local.family
  vpc_id                           = module.vpc.vpc_id
  allowed_security_groups          = local.allowed_security_groups
  subnet_ids                       = module.vpc.database_subnets ## db subnets
  environment                      = local.environment
  kms_key_arn                      = module.kms.key_arn
=======
  # source                           = "squareops/rds-postgresql/aws"
  source   = "../../"
  name     = local.name
  db_name  = "test"
  multi_az = "true"
  family   = local.family
  # vpc_id                           = module.vpc.vpc_id
  vpc_id                  = "vpc-0596c94ef9a8c1cf3"
  allowed_security_groups = local.allowed_security_groups
  # subnet_ids                       = module.vpc.database_subnets ## db subnets
  subnet_ids  = ["subnet-02d397a523ad1b92c", "subnet-0786584f53f23322d"]
  environment = local.environment
  kms_key_arn = "arn:aws:kms:us-east-1:767398031518:key/b2b4a98b-ea65-4ebd-b304-0660735e1580"
  # kms_key_arn                      = module.kms.key_arn
>>>>>>> Stashed changes
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
  deletion_protection              = false
  cloudwatch_metric_alarms_enabled = false
  alarm_cpu_threshold_percent      = 70
  disk_free_storage_space          = "10000000" # in bytes
  slack_notification_enabled       = false
  slack_username                   = "Admin"
  slack_channel                    = "postgresql-notification"
  slack_webhook_url                = "https://hooks/xxxxxxxx"
  custom_user_password             = local.custom_user_password
  #if you want backup and restore then you have to create your cluster with rds vpc id , private subnets, kms key.
  #And allow cluster security group in rds security group
<<<<<<< Updated upstream
  cluster_name              = ""
=======
  cluster_name              = "non-prod-15nov"
>>>>>>> Stashed changes
  namespace                 = local.namespace
  create_namespace          = local.create_namespace
  postgresdb_backup_enabled = false
  postgresdb_backup_config = {
<<<<<<< Updated upstream
    postgres_database_name = ""                             # Specify the database name or Leave empty if you wish to backup all databases
=======
    postgres_database_name = "dummydb"                      # Specify the database name or Leave empty if you wish to backup all databases
>>>>>>> Stashed changes
    cron_for_full_backup   = "*/2 * * * *"                  # set cronjob for backup
    bucket_uri             = "s3://mongodb-backups-atmosly" # s3 bucket uri
  }
  postgresdb_restore_enabled = true
  postgresdb_restore_config = {
    bucket_uri       = "s3://mongodb-backups-atmosly" #S3 bucket URI (without a trailing slash /) containing the backup dump file.
<<<<<<< Updated upstream
    backup_file_name = "db5_20241114111607.sql"       #Give .sql or .zip file for restore
=======
    backup_file_name = "dummydb_20241115100801.sql"   #Give .sql or .zip file for restore
>>>>>>> Stashed changes
  }
}
