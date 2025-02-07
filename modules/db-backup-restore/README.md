# db-backup-restore

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.postgres_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.postgres_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [helm_release.postgresdb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.postgresdb_restore](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.postgresdb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_container_name"></a> [azure\_container\_name](#input\_azure\_container\_name) | Azure container name | `string` | `""` | no |
| <a name="input_azure_storage_account_key"></a> [azure\_storage\_account\_key](#input\_azure\_storage\_account\_key) | Azure storage account key | `string` | `""` | no |
| <a name="input_azure_storage_account_name"></a> [azure\_storage\_account\_name](#input\_azure\_storage\_account\_name) | Azure storage account name | `string` | `""` | no |
| <a name="input_bucket_provider_type"></a> [bucket\_provider\_type](#input\_bucket\_provider\_type) | Choose what type of provider you want (s3, gcs) | `string` | `"s3"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the MySQL application on. | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `false` | no |
| <a name="input_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#input\_iam\_role\_arn\_backup) | IAM role ARN for backup (AWS) | `string` | `""` | no |
| <a name="input_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#input\_iam\_role\_arn\_restore) | IAM role ARN for restore (AWS) | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the MYSQL deployment will be deployed. | `string` | `"postgresdb"` | no |
| <a name="input_postgresdb_backup_config"></a> [postgresdb\_backup\_config](#input\_postgresdb\_backup\_config) | configuration options for MySQL database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups. | `map(string)` | <pre>{<br/>  "bucket_uri": "",<br/>  "cron_for_full_backup": "",<br/>  "postgres_database_name": "",<br/>  "s3_bucket_region": ""<br/>}</pre> | no |
| <a name="input_postgresdb_backup_enabled"></a> [postgresdb\_backup\_enabled](#input\_postgresdb\_backup\_enabled) | Specifies whether to enable backups for MySQL database. | `bool` | `false` | no |
| <a name="input_postgresdb_permission"></a> [postgresdb\_permission](#input\_postgresdb\_permission) | access | `bool` | `false` | no |
| <a name="input_postgresdb_restore_config"></a> [postgresdb\_restore\_config](#input\_postgresdb\_restore\_config) | Configuration options for restoring dump to the MySQL database. | `any` | <pre>{<br/>  "DB_NAME": "",<br/>  "backup_file_name": "",<br/>  "bucket_uri": "",<br/>  "file_name": ""<br/>}</pre> | no |
| <a name="input_postgresdb_restore_enabled"></a> [postgresdb\_restore\_enabled](#input\_postgresdb\_restore\_enabled) | Specifies whether to enable restoring dump to the MySQL database. | `bool` | `false` | no |
| <a name="input_service_account_backup"></a> [service\_account\_backup](#input\_service\_account\_backup) | Service account for backup (GCP) | `string` | `""` | no |
| <a name="input_service_account_restore"></a> [service\_account\_restore](#input\_service\_account\_restore) | Service account for restore (GCP) | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
