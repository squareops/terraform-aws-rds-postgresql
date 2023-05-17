locals {
  region         = "us-east-2"
  name           = "skaf"
  vpc_id         = "vpc-00ae5511ee10671c1"
  family         = "postgres15"
  subnet_ids     = ["subnet-0d9a81939c6dd2a6e","subnet-0fd26f0d73dc9e73d"]
  environment    = "prod"
  kms_key_arn    = "arn:aws:kms:us-east-2:271251951598:key/73ff9e84-83e1-4097-b388-fe29623338a9"
  engine_version = "15.2"
  instance_class = "db.m5d.large"
  allowed_security_groups = ["sg-0a680184e11eafd35"]
}

module "rds-pg" {
  source                           = "git@github.com:sq-ia/terraform-aws-rds-postgresql.git"
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
