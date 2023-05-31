locals {
  region         = "us-east-2"
  name           = "postgresql"
  vpc_id         = "vpc-00ae5571c1"
  family         = "postgres15"
  subnet_ids     = ["subnet-0d9a8193d2a6e","subnet-0fd263dc9e73d"]
  environment    = "prod"
  kms_key_arn    = "arn:aws:kms:us-east-2:22222222:key/73ff9e84-83e1-fe29623338a9"
  engine_version = "15.2"
  instance_class = "db.m5d.large"
  allowed_security_groups = ["sg-0a680afd35"]
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "rds-pg" {
  source                           = "squareops/postgresql-rds/aws"
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
}
