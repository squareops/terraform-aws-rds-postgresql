resource "kubernetes_namespace" "postgresdb" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "postgresdb_backup" {
  count      = var.postgresdb_backup_enabled ? 1 : 0
  depends_on = [kubernetes_namespace.postgresdb]
  name       = "postgresdb-backup"
  chart      = "../../modules/db-backup-restore/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/../../helm/values/backup/values.yaml", {
      bucket_uri             = var.postgresdb_backup_config.bucket_uri,
      postgres_database_name = var.postgresdb_backup_config.postgres_database_name,
      db_endpoint            = var.postgresdb_backup_config.db_endpoint,
      db_password            = var.postgresdb_backup_config.db_password,
      db_username            = var.postgresdb_backup_config.db_username,
      # s3_bucket_region           = var.postgresdb_backup_config.s3_bucket_region ,
      cron_for_full_backup = var.postgresdb_backup_config.cron_for_full_backup,
      annotations          = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.postgres_backup_role[count.index].arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_backup}"
    })
  ]
}


## DB dump restore
resource "helm_release" "postgresdb_restore" {
  count      = var.postgresdb_restore_enabled ? 1 : 0
  depends_on = [kubernetes_namespace.postgresdb]
  name       = "postgresdb-restore"
  chart      = "../../modules/db-backup-restore/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/../../helm/values/restore/values.yaml", {
      bucket_uri       = var.postgresdb_restore_config.bucket_uri,
      db_endpoint      = var.postgresdb_restore_config.db_endpoint,
      db_password      = var.postgresdb_restore_config.db_password,
      db_username      = var.postgresdb_restore_config.db_username,
      backup_file_name = var.postgresdb_restore_config.backup_file_name,
      annotations      = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.postgres_restore_role[count.index].arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_restore}"
    })
  ]
}
