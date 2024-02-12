resource "aws_iam_role" "postgres_backup_role" { # need to add condition 
# count = var.mysqldb_backup_enabled  ? 1 : 0
  name = format("%s-%s-%s", var.cluster_name, var.name, "postgres-backup-rds")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-postgres-backup"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}


resource "aws_iam_role" "postgres_restore_role" {
  # count = var.mysqldb_restore_enabled  ? 1 : 0
  name = format("%s-%s-%s", var.cluster_name, var.name, "postgres-restore")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-postgres-restore"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}