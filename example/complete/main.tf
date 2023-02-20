locals {
  region = "us-east-2"
  name = "skaf"
  environment = "production"
  engine_version = "13"
  instance_class = "db.m5.large"
}

module "rds-pg" {
  source  = "../../"
  engine              = "postgres"
  engine_version      = local.engine_version
  instance_class      = local.instance_class
  allocated_storage   = "20"
  storage_encrypted   = true
  kms_key_arn          = "arn:aws:kms:us-east-2:271251951598:key/7fa600be-9c08-4502-a67a-ed7e8bc332cb"
  publicly_accessible = false
  replicate_source_db = null
  db_name             = "postgres"
  master_username     = "pguser" 
  port                             = "5432"
  multi_az                         = "false"
  subnet_ids                       = ["subnet-0dd83181b1c69eee8","subnet-095b80a737aea6d0f"]
  skip_final_snapshot              = false
  final_snapshot_identifier_prefix = "final"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  backup_window                    = "03:00-06:00"
  backup_retention_period          = 1
  apply_immediately                = true
  random_password_length           = 10
  create_random_password           = true
  allowed_security_groups  = ["sg-03472c1a5f35c026d"]
  allowed_cidr_blocks      = []
  vpc_id                   = "vpc-06db5c1d1b2ec66f8"
  family = "postgres13"
  major_engine_version = "13"
  deletion_protection = true
}



