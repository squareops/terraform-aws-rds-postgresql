data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {

  db_password = var.custom_user_password != "" ? var.custom_user_password : (
    length(random_password.master) > 0 ? element(random_password.master, 0).result : var.custom_user_password
  )

  tags = {
    Automation  = "true"
    Environment = var.environment
  }
}

module "db" {
  source                                = "terraform-aws-modules/rds/aws"
  version                               = "6.1.0"
  identifier                            = format("%s-%s", var.environment, var.name)
  db_name                               = var.db_name
  port                                  = var.port
  engine                                = var.engine
  username                              = var.master_username
  password                              = var.custom_user_password != "" ? var.custom_user_password : var.manage_master_user_password ? null : length(random_password.master) > 0 ? random_password.master[0].result : null
  multi_az                              = var.multi_az
  subnet_ids                            = var.subnet_ids
  kms_key_id                            = var.kms_key_arn
  instance_class                        = var.instance_class
  storage_type                          = var.storage_type
  engine_version                        = var.engine_version
  allocated_storage                     = var.allocated_storage
  storage_encrypted                     = var.storage_encrypted
  max_allocated_storage                 = var.enable_storage_autoscaling && var.max_allocated_storage != "" ? var.max_allocated_storage : null
  publicly_accessible                   = var.publicly_accessible
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_db_subnet_group                = var.create_db_subnet_group
  replicate_source_db                   = var.replicate_source_db
  vpc_security_group_ids                = split(",", module.security_group_rds.security_group_id)
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  apply_immediately                     = var.apply_immediately
  backup_retention_period               = var.backup_retention_period
  manage_master_user_password           = var.manage_master_user_password ? true : false
  monitoring_interval                   = "30"
  monitoring_role_name                  = format("%s-%s-RDSPostgresql", var.name, var.environment)
  create_monitoring_role                = true
  final_snapshot_identifier_prefix      = var.final_snapshot_identifier_prefix
  enabled_cloudwatch_logs_exports       = ["postgresql"]
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
  count                            = var.replica_enable ? var.replica_count : 0
  identifier                       = format("%s-%s-%s", var.environment, var.name, "replica")
  port                             = var.port
  engine                           = var.engine
  multi_az                         = var.multi_az
  kms_key_id                       = var.kms_key_arn
  instance_class                   = var.instance_class
  storage_type                     = var.storage_type
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
  monitoring_role_arn              = module.db.enhanced_monitoring_iam_role_arn
  create_monitoring_role           = false
  create_cloudwatch_log_group      = false
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
  depends_on          = [module.db]
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
  version     = "~> 5.0"
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
    { "Name" = format("%s/%s/%s", var.environment, var.name, "rds-postgres-pass") },
    local.tags,
  )
}

resource "random_password" "master" {
  count   = var.manage_master_user_password ? 0 : var.custom_user_password == "" ? 1 : 0
  length  = var.random_password_length
  special = false
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.secret_master_db.id
  secret_string = jsonencode({
    username = module.db.db_instance_username
    password = local.db_password
    engine   = var.engine
    host     = module.db.db_instance_endpoint
  })
}

# Cloudwatch alarms
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  alarm_name          = format("%s-%s-%s", var.environment, var.name, "cpu-utilization")
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_identifier
  }

  alarm_actions = [aws_sns_topic.slack_topic[0].arn]
  ok_actions    = [aws_sns_topic.slack_topic[0].arn]
  depends_on    = [aws_sns_topic.slack_topic]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "cpu_metric") },
    local.tags,
  )
}

resource "aws_cloudwatch_metric_alarm" "disk_free_storage_space_too_low" {
  count               = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  alarm_name          = format("%s-%s-%s", var.environment, var.name, "free-storage-space")
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"

  threshold = var.disk_free_storage_space

  dimensions = {
    DBInstanceIdentifier = module.db.db_instance_identifier
  }

  alarm_actions = [aws_sns_topic.slack_topic[0].arn]
  ok_actions    = [aws_sns_topic.slack_topic[0].arn]
  depends_on    = [aws_sns_topic.slack_topic]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "free-storage-space") },
    local.tags,
  )
}

resource "aws_kms_key" "this" {
  count       = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  description = "KMS key for notify-slack test"
}

resource "aws_kms_ciphertext" "slack_url" {
  count     = var.slack_notification_enabled && var.cloudwatch_metric_alarms_enabled ? 1 : 0
  plaintext = var.slack_webhook_url
  key_id    = aws_kms_key.this[0].arn
}

resource "aws_sns_topic" "slack_topic" {
  count           = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  depends_on      = [module.db]
  name            = format("%s-%s-%s", var.environment, var.name, "slack-topic")
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

data "archive_file" "lambdazip" {
  count       = var.slack_notification_enabled ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/lambda/sns_slack.zip"

  source_dir = "${path.module}/lambda/"
}


module "cw_sns_slack" {
  count  = var.slack_notification_enabled ? 1 : 0
  source = "./lambda"

  name          = format("%s-%s-%s", var.environment, var.name, "sns-slack")
  description   = "notify slack channel on sns topic"
  artifact_file = "${path.module}/lambda/sns_slack.zip"
  handler       = "sns_slack.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 128
  timeout       = 30
  environment = {
    "SLACK_URL"     = var.slack_webhook_url
    "SLACK_CHANNEL" = var.slack_channel
    "SLACK_USER"    = var.slack_username
  }
  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "lambda") },
    local.tags,
  )
}

resource "aws_sns_topic_subscription" "slack-endpoint" {
  count                  = var.slack_notification_enabled ? 1 : 0
  endpoint               = module.cw_sns_slack[0].arn
  protocol               = "lambda"
  endpoint_auto_confirms = true
  topic_arn              = aws_sns_topic.slack_topic[0].arn
}

resource "aws_lambda_permission" "sns_lambda_slack_invoke" {
  count         = var.slack_notification_enabled ? 1 : 0
  statement_id  = "sns_slackAllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.cw_sns_slack[0].arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.slack_topic[0].arn
}

module "backup_restore" {
  depends_on                = [module.db]
  source                    = "./modules/db-backup-restore"
  name                      = var.name
  cluster_name              = var.cluster_name
  namespace                 = var.namespace
  create_namespace          = var.create_namespace
  postgresdb_backup_enabled = var.postgresdb_backup_enabled
  postgresdb_backup_config = {
    db_username            = var.master_username
    db_password            = var.custom_user_password != "" ? var.custom_user_password : nonsensitive(random_password.master[0].result)
    postgres_database_name = var.postgresdb_backup_config.postgres_database_name
    cron_for_full_backup   = var.postgresdb_backup_config.cron_for_full_backup
    bucket_uri             = var.postgresdb_backup_config.bucket_uri
    db_endpoint            = replace(var.replica_enable ? module.db_replica[0].db_instance_endpoint : module.db.db_instance_endpoint, ":5432", "")
  }

  postgresdb_restore_enabled = var.postgresdb_restore_enabled
  postgresdb_restore_config = {
    db_endpoint      = replace(var.replica_enable ? module.db_replica[0].db_instance_endpoint : module.db.db_instance_endpoint, ":5432", "")
    db_username      = var.master_username
    db_password      = var.custom_user_password != "" ? var.custom_user_password : nonsensitive(random_password.master[0].result)
    bucket_uri       = var.postgresdb_restore_config.bucket_uri
    backup_file_name = var.postgresdb_restore_config.backup_file_name,
  }
}
