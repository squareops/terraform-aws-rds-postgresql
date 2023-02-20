variable "additional_tags" {
  description = "Tags for resources "
  type        = map(string)
  default = {
    automation = "true"
  }
}

variable "allocated_storage" {
  description = "Database storage capacity"
  default     = 20
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  default     = []
  type        = list(any)
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  default     = []
  type        = list(any)
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  default     = false
  type        = bool
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "backup_window" {
  description = "When to perform DB backups"
  default     = ""
  type        = string
}

variable "create_random_password" {
  description = "Whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "create security group or not"
  default     = true
  type        = bool
}

variable "deletion_protection" {
  description = "provide accidental deletion protection"
  default     = true
  type        = bool
}

variable "enable_ssl_connection" {
  description = "Whether or not to enable the ssl connection"
  default     = false
  type        = bool
}

variable "db_name" {
  description = "Name for an automatically created database on cluster creation"
  default     = ""
  type        = string
}


variable "engine" {
  description = "The name of the database engine to be used for this DB cluster."
  default     = ""
  type        = string
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage."
  default     = ""
  type        = string
}

variable "environment" {
  description = "Select enviroment type: dev, demo, prod"
  default     = "demo"
  type        = string
}

variable "family" {
  description = "Version of mysql DB family being created"
  default     = ""
  type        = string
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "Instance type"
  default     = "db.m5.large"
  type        = string
}

variable "major_engine_version" {
  description = "The database major engine version. Updating this argument results in an outage."
  default     = ""
  type        = string
}

variable "master_username" {
  description = "Create username for RDS primary cluster"
  default     = ""
  type        = string
}

variable "maintenance_window" {
  description = "When to perform DB maintenance"
  default     = ""
  type        = string
}

variable "multi_az" {
  description = "enable multi AZ for disaster Recovery"
  default     = false
  type        = bool
}

variable "rds_instance_name" {
  description = "RDS instance name"
  default     = "abc"
  type        = string
}

variable "port" {
  description = "port for database"
  type        = number
  default     = 3306
}

variable "publicly_accessible" {
  description = "Publicly accessible to the internet"
  default     = false
  type        = bool
}

variable "random_password_length" {
  description = "(Optional) Length of random password to create. (default: 10)"
  type        = number
  default     = 10
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Allow Database encryption or not"
  default     = true
  type        = bool
}

variable "subnet_ids" {
  description = "List of subnet IDs used by database subnet group created"
  default     = []
  type        = list(any)
}

variable "vpc_id" {
  description = "In which VPC do you want to deploy the RDS cluster"
  default     = ""
  type        = string
}