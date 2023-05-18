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
  default     = ""
  type        = string
}

variable "create_random_password" {
  description = "Whether to create a random password for the RDS primary cluster"
  type        = bool
  default     = true
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
  default     = ""
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
  description = "The length of the randomly generated password for the RDS primary cluster (default: 10)"
  type        = number
  default     = 10
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a replicate database, and uses the specified value as the source database identifier"
  type        = string
  default     = null
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