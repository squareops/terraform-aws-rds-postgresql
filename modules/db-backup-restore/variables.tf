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

variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
  default     = ""
}

variable "azure_storage_account_key" {
  description = "Azure storage account key"
  type        = string
  default     = ""
}

variable "azure_container_name" {
  description = "Azure container name"
  type        = string
  default     = ""
}

variable "namespace" {
  type        = string
  default     = "postgresdb"
  description = "Name of the Kubernetes namespace where the MYSQL deployment will be deployed."
}

variable "create_namespace" {
  type        = string
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
  default     = false
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
  description = "Specifies the name of the EKS cluster to deploy the MySQL application on."
}

variable "postgresdb_permission" {
  default     = false
  description = "access"
  type        = bool
}

variable "bucket_provider_type" {
  type        = string
  default     = "s3"
  description = "Choose what type of provider you want (s3, gcs)"
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

variable "postgresdb_backup_config" {
  type = map(string)
  default = {
    bucket_uri             = ""
    cron_for_full_backup   = ""
    postgres_database_name = ""

  }
  description = "configuration options for MySQL database backups. It includes properties such as the S3 bucket URI, and the cron expression for full backups."
}

variable "postgresdb_restore_config" {
  type = any
  default = {
    bucket_uri = ""
    backup_file_name = ""
  }
  description = "Configuration options for restoring dump to the MySQL database."
}
