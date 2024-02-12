variable "postgresql_backup_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable backups for PostgreSQL database."
}
variable "namespace" {
  type        = string
  default     = "postgresdb"
  description = "Name of the Kubernetes namespace where the PostgreSQL deployment will be deployed."
}
variable "bucket_provider_type" {
  type        = string
  default     = "gcs"
  description = "Choose what type of provider you want (s3, gcs)"
}

variable "port" {
  description = "The port number for the database"
  type        = string
  default     = "5432"
}

variable "iam_role_arn_backup" {
  description = "IAM role ARN for backup (AWS)"
  type        = string
  default     = ""
}
variable "service_account_backup" {
  description = "Service account for backup (GCP)"
  type        = string
  default     = ""
}
# variable "mysqldb_custom_credentials_config" {
#   type = any
#   default = {
#     root_user            = ""
#     root_password        = ""
#   }
#   description = "Specify the configuration settings for MySQL to pass custom credentials during creation"
# }
variable "postgres_backup_config" {
  type = map(string)
  default = {
    bucket_uri           = ""
    s3_bucket_region     = ""
    cron_for_full_backup = ""
    db_endpoint=""
  }
  description = "configuration options for PostgreSQL database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups."
}
variable "create_namespace" {
  type        = string
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
  default     = true
}

#restore

variable "postgres_restore_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable restoring dump to the PostgreSQL database."
}

variable "postgres_restore_config" {
  type = any
  default = {
    bucket_uri       = ""
    file_name        = ""
    s3_bucket_region = ""
  }
  description = "Configuration options for restoring dump to the PostgreSQL database."
}

variable "iam_role_arn_restore" {
  description = "IAM role ARN for restore (AWS)"
  type        = string
  default     = ""
}

variable "service_account_restore" {
  description = "Service account for restore (GCP)"
  type        = string
  default     = ""
}

# two variable of clustername and name
variable "name" {
  description = "Name identifier for module to be added as suffix to resources"
  type        = string
  default     = "test"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the PostgreSQL application on."
}
