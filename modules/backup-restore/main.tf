locals {
  oidc_provider = replace(
    data.aws_eks_cluster.kubernetes_cluster.identity[0].oidc[0].issuer,
    "/^https:///",
    ""
  )
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "kubernetes_cluster" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "postgresql" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "postgres_backup" {
  count      = var.postgresql_backup_enabled ? 1 : 0
  name       = "postgresql-backup"
  chart      = "../../modules/backup-restore/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("../../helm/values/backup/values.yaml", {
      bucket_uri                 = var.postgres_backup_config.bucket_uri,
      db_endpoint                = var.bucket_provider_type == "s3" ? var.postgres_backup_config.db_endpoint : "",
      db_password                = var.bucket_provider_type == "s3" ? var.postgres_backup_config.db_password : "",
      db_username                = var.bucket_provider_type == "s3" ? var.postgres_backup_config.db_username : "",
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.postgres_backup_config.s3_bucket_region : "",
      port                       = var.bucket_provider_type == "s3" ? var.port : "",
      cron_for_full_backup       = var.postgres_backup_config.cron_for_full_backup,
      custom_user_username       = "pguser",
      bucket_provider_type       = var.bucket_provider_type,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn:  ${aws_iam_role.postgres_backup_role.arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_backup}"
    })
  ]
}


resource "helm_release" "postgres_restore" {
  count      = var.postgres_restore_enabled ? 1 : 0
  name       = "postgres-restore"
  chart      = "../../modules/backup-restore/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("../../helm/values/restore/values.yaml", {
      bucket_uri                 = var.postgres_restore_config.bucket_uri,
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.postgres_restore_config.s3_bucket_region : "",
      db_endpoint                = var.bucket_provider_type == "s3" ? var.postgres_restore_config.db_endpoint : "",
      db_password                = var.bucket_provider_type == "s3" ? var.postgres_restore_config.db_password : "",
      db_username                = var.bucket_provider_type == "s3" ? var.postgres_restore_config.db_username : "",
      port                       = var.bucket_provider_type == "s3" ? var.port : "",
      custom_user_username       = "admin",
      bucket_provider_type       = var.bucket_provider_type,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.postgres_restore_role.arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_restore}"
    })
  ]
}