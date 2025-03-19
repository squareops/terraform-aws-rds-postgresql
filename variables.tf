variable "additional_tags" {
  description = "A map of additional tags to apply to the AWS resources"
  type        = map(string)
  default = {
    automation = "true"
  }
}

variable "allocated_storage" {
  description = "The allocated storage capacity for the database in gibibytes (GiB)"
  default     = 20
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks that are allowed to access the database"
  default     = []
  type        = list(any)
}

variable "allowed_security_groups" {
  description = "A list of Security Group IDs to allow access to the database"
  default     = []
  type        = list(any)
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately or during the next maintenance window"
  default     = false
  type        = bool
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  type        = number
  default     = 5
}

variable "backup_window" {
  description = "The preferred window for taking automated backups of the database"
  default     = "03:00-06:00"
  type        = string
}

variable "manage_master_user_password" {
  description = "Whether to manage the master user password of the RDS primary cluster automatically"
  type        = bool
  default     = false
}

variable "create_security_group" {
  description = "Whether to create a security group for the database"
  default     = true
  type        = bool
}

variable "deletion_protection" {
  description = "Specifies whether accidental deletion protection is enabled"
  default     = true
  type        = bool
}

variable "enable_ssl_connection" {
  description = "Whether to enable SSL connection to the database"
  default     = false
  type        = bool
}

variable "db_name" {
  description = "The name of the automatically created database on cluster creation"
  default     = ""
  type        = string
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster"
  default     = "postgres"
  type        = string
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Select enviroment type: dev, demo, prod"
  default     = ""
  type        = string
}

variable "family" {
  description = "The version of the Postgresql DB family being created"
  default     = "postgres15"
  type        = string
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name for the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. Set this to the destination KMS ARN when creating an encrypted replica. If storage_encrypted is set to true and kms_key_id is not specified, the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type for the database"
  default     = "db.m5.large"
  type        = string
}

variable "major_engine_version" {
  description = "The major engine version for the database. Updating this argument results in an outage"
  default     = ""
  type        = string
}

variable "master_username" {
  description = "The username for the RDS primary cluster"
  default     = ""
  type        = string
}

variable "maintenance_window" {
  description = "The preferred window for performing database maintenance"
  default     = "Mon:00:00-Mon:03:00"
  type        = string
}

variable "multi_az" {
  description = "Enable multi-AZ for disaster recovery"
  default     = false
  type        = bool
}

variable "name" {
  description = "The name of the RDS instance"
  default     = ""
  type        = string
}

variable "port" {
  description = "The port number for the database"
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  description = "Specifies whether the RDS instance is publicly accessible over the internet"
  default     = false
  type        = bool
}

variable "random_password_length" {
  description = "The length of the randomly generated password for the RDS primary cluster (default: 16)"
  type        = number
  default     = 16
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a replicate database, and uses the specified value as the source database identifier"
  type        = string
  default     = null
}

variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If set to true, no DB snapshot is created. If set to false, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "snapshot_identifier" {
  description = "Specifies whether to create the database from a snapshot. Use the snapshot ID found in the RDS console, e.g., rds:production-2015-06-26-06-05"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether to enable database encryption"
  default     = true
  type        = bool
}

variable "subnet_ids" {
  description = "A list of subnet IDs used by the database subnet group"
  default     = []
  type        = list(any)
}

variable "vpc_id" {
  description = "The ID of the VPC where the RDS cluster will be deployed"
  default     = ""
  type        = string
}

variable "disk_free_storage_space" {
  type        = string
  default     = "10000000000" // 10 GB
  description = "Alarm threshold for the 'lowFreeStorageSpace' alarm"
}

variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable CloudWatch metrics alarms"
  default     = false
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "CPU threshold alarm level"
}

variable "alarm_actions" {
  type        = list(string)
  description = "Alarm action list"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
  default     = []
}

variable "slack_notification_enabled" {
  type        = bool
  description = "Whether to enable/disable slack notification."
  default     = false
}

variable "slack_webhook_url" {
  description = "The Slack Webhook URL where notifications will be sent."
  default     = ""
  type        = string
}

variable "slack_channel" {
  description = "The Slack channel where notifications will be posted."
  default     = ""
  type        = string
}

variable "slack_username" {
  description = "The username to use when sending notifications to Slack."
  default     = ""
  type        = string
}

variable "cw_sns_topic_arn" {
  description = "The username to use when sending notifications to Slack."
  default     = ""
  type        = string
}

variable "enable_storage_autoscaling" {
  description = "Whether enable storage autoscaling or not"
  default     = true
  type        = bool
}

variable "max_allocated_storage" {
  description = "The Maximum storage capacity for the database value after autoscaling"
  default     = null
  type        = number
}

variable "storage_type" {
  description = "The storage type for the database storage like gp2,gp3,io1"
  default     = "gp2"
  type        = string
}

variable "replica_enable" {
  description = "Whether enable replica DB"
  default     = false
  type        = bool
}

variable "replica_count" {
  description = "The number of replica instance"
  default     = 1
  type        = number
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31`"
  type        = number
  default     = 7
}

variable "custom_user_password" {
  description = "Custom password for the RDS master user"
  default     = ""
  type        = string
}

variable "create_namespace" {
  type        = string
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
  default     = false
}

variable "namespace" {
  type        = string
  default     = "postgresdb"
  description = "Name of the Kubernetes namespace where the MYSQL deployment will be deployed."
}

variable "postgresdb_backup_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable backups for MySQL database."
}

variable "postgresdb_restore_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable restoring dump to the MySQL database."
}


variable "bucket_provider_type" {
  type        = string
  default     = "s3"
  description = "Choose what type of provider you want (s3, gcs)"
}

variable "postgresdb_backup_config" {
  type = map(string)
  default = {
    bucket_uri = ""
    cron_for_full_backup   = ""
    postgres_database_name = ""

  }
  description = "configuration options for MySQL database backups. It includes properties such as the S3 bucket region, and the cron expression for full backups."
}

variable "postgresdb_restore_config" {
  type = any
  default = {
    bucket_uri = ""
    file_name  = ""
  }
  description = "Configuration options for restoring dump to the MySQL database."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the MySQL application on."
}
