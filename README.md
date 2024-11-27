# RDS PostgresQL
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This Terraform module provisions an Amazon RDS PostgreSQL database on AWS. Amazon RDS (Relational Database Service) is a managed database service that makes it easy to set up, operate, and scale a relational database in the cloud. This module focuses specifically on PostgreSQL database deployments.

## Features

  1. Creates an Amazon RDS PostgreSQL database with customizable configurations.
  2. Supports various PostgreSQL versions and allows for easy updates.
  3. Configurable database instance class, storage capacity, and other PostgreSQL-specific settings.
  4. Provides options for enabling multi-AZ deployment for enhanced availability and disaster recovery.
  5. Allows customization of backup retention period and automated backups.
  6. Supports encryption at rest using AWS Key Management Service (KMS) for enhanced security.
  7. Enables fine-grained control over network access through security groups and VPC settings.
  8. Offers customizable tags for resource categorization and management.
  9. CloudWatch Alerts: Set up CloudWatch alarms to monitor the health and performance of your Redis cluster. Integrate these alarms with AWS Simple Notification Service (SNS) to receive real-time alerts. Use AWS Lambda functions to customize your alerting logic, and send notifications to Slack channels for immediate visibility into your RDS POstgresql status.
  10. Supports useful features to enable storage autoscaling and Replica configuration with desired number of replicas.

## Usage Examples
```hcl
module "rds-pg" {
  source                           = "squareops/rds-postgresql/aws"
  name                             = "postgresql"
  db_name                          = "proddb"
  vpc_id                           = "vpc-047eb8acfb73"
  multi_az                         = false
  subnet_ids                       = ["subnet-b39cfc", "subnet-090b8d8"]
  environment                      = "prod"
  create_namespace                 = true
  storage_type                     = "gp3"
  cluster_name                     = ""
  replica_enable                   = false
  replica_count                    = 1
  kms_key_arn                      = "arn:aws:kms:region:2222222222:key/f8c8d802-a34b"
  storage_type                     = "gp3"
  engine_version                   = "15.2"
  instance_class                   = "db.m5.large"
  master_username                  = "pguser"
  allocated_storage                = "20"
  publicly_accessible              = false
  skip_final_snapshot              = true
  backup_window                    = "03:00-06:00"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  major_engine_version             = "15.2"
  deletion_protection              = false
  allowed_security_groups          = ["sg-013cbf880"]
  final_snapshot_identifier_prefix = "final"
  cloudwatch_metric_alarms_enabled = true
  alarm_cpu_threshold_percent      = 70
  disk_free_storage_space          = "10000000" # in bytes
  slack_username                   = "John"
  slack_channel                    = "skaf-dev"
  slack_webhook_url                = "https://hooks/xxxxxxxx"
  custom_user_password             = "postgresqlpasswd"
    cluster_name              = ""
  namespace                 = local.namespace
  create_namespace          = local.create_namespace
  postgresdb_backup_enabled = false
  postgresdb_backup_config = {
    postgres_database_name = "" # Specify the database name or Leave empty if you wish to backup all databases
    cron_for_full_backup   = "*/2 * * * *" # set cronjob for backup
    bucket_uri             = "s3://mongodb-backups-atmosly" # s3 bucket uri
  }
  postgresdb_restore_enabled = false
  postgresdb_restore_config = {
    bucket_uri       = "s3://mongodb-backups-atmosly" #S3 bucket URI (without a trailing slash /) containing the backup dump file.
    backup_file_name = "db5_20241114111607.sql"  #Give .sql or .zip file for restore
  }
}
```
Refer [examples](https://github.com/squareops/terraform-aws-rds-postgresql/tree/main/examples) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/squareops/terraform-aws-rds-postgresql/blob/main/IAM.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_restore"></a> [backup\_restore](#module\_backup\_restore) | ./modules/db-backup-restore | n/a |
| <a name="module_cw_sns_slack"></a> [cw\_sns\_slack](#module\_cw\_sns\_slack) | ./lambda | n/a |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | 6.1.0 |
| <a name="module_db_replica"></a> [db\_replica](#module\_db\_replica) | terraform-aws-modules/rds/aws | 6.1.0 |
| <a name="module_security_group_rds"></a> [security\_group\_rds](#module\_security\_group\_rds) | terraform-aws-modules/security-group/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cache_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_free_storage_space_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_kms_ciphertext.slack_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_ciphertext) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_permission.sns_lambda_slack_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.secret_master_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group_rule.cidr_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_sns_topic.slack_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.slack-endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_password.master](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.lambdazip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A map of additional tags to apply to the AWS resources | `map(string)` | <pre>{<br/>  "automation": "true"<br/>}</pre> | no |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | Alarm action list | `list(string)` | `[]` | no |
| <a name="input_alarm_cpu_threshold_percent"></a> [alarm\_cpu\_threshold\_percent](#input\_alarm\_cpu\_threshold\_percent) | CPU threshold alarm level | `number` | `75` | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage capacity for the database in gibibytes (GiB) | `number` | `20` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks that are allowed to access the database | `list(any)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group IDs to allow access to the database | `list(any)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately or during the next maintenance window | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The number of days to retain backups for | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The preferred window for taking automated backups of the database | `string` | `"03:00-06:00"` | no |
| <a name="input_bucket_provider_type"></a> [bucket\_provider\_type](#input\_bucket\_provider\_type) | Choose what type of provider you want (s3, gcs) | `string` | `"s3"` | no |
| <a name="input_cloudwatch_metric_alarms_enabled"></a> [cloudwatch\_metric\_alarms\_enabled](#input\_cloudwatch\_metric\_alarms\_enabled) | Boolean flag to enable/disable CloudWatch metrics alarms | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the MySQL application on. | `string` | `""` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Whether to create a database subnet group | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a security group for the database | `bool` | `true` | no |
| <a name="input_custom_user_password"></a> [custom\_user\_password](#input\_custom\_user\_password) | Custom password for the RDS master user | `string` | `""` | no |
| <a name="input_cw_sns_topic_arn"></a> [cw\_sns\_topic\_arn](#input\_cw\_sns\_topic\_arn) | The username to use when sending notifications to Slack. | `string` | `""` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the automatically created database on cluster creation | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Specifies whether accidental deletion protection is enabled | `bool` | `true` | no |
| <a name="input_disk_free_storage_space"></a> [disk\_free\_storage\_space](#input\_disk\_free\_storage\_space) | Alarm threshold for the 'lowFreeStorageSpace' alarm | `string` | `"10000000000"` | no |
| <a name="input_enable_ssl_connection"></a> [enable\_ssl\_connection](#input\_enable\_ssl\_connection) | Whether to enable SSL connection to the database | `bool` | `false` | no |
| <a name="input_enable_storage_autoscaling"></a> [enable\_storage\_autoscaling](#input\_enable\_storage\_autoscaling) | Whether enable storage autoscaling or not | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster | `string` | `"postgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The database engine version. Updating this argument results in an outage | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Select enviroment type: dev, demo, prod | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | The version of the Postgresql DB family being created | `string` | `"postgres15"` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name for the final snapshot on cluster destroy | `string` | `"final"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type for the database | `string` | `"db.m5.large"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key. Set this to the destination KMS ARN when creating an encrypted replica. If storage\_encrypted is set to true and kms\_key\_id is not specified, the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The preferred window for performing database maintenance | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | The major engine version for the database. Updating this argument results in an outage | `string` | `""` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Whether to manage the master user password of the RDS primary cluster automatically | `bool` | `false` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The username for the RDS primary cluster | `string` | `""` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | The Maximum storage capacity for the database value after autoscaling | `number` | `null` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-AZ for disaster recovery | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the RDS instance | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the MYSQL deployment will be deployed. | `string` | `"postgresdb"` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | `false` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Valid values are `7`, `731` (2 years) or a multiple of `31` | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number for the database | `number` | `5432` | no |
| <a name="input_postgresdb_backup_config"></a> [postgresdb\_backup\_config](#input\_postgresdb\_backup\_config) | configuration options for MySQL database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups. | `map(string)` | <pre>{<br/>  "bucket_uri": "",<br/>  "cron_for_full_backup": "",<br/>  "postgres_database_name": ""<br/>}</pre> | no |
| <a name="input_postgresdb_backup_enabled"></a> [postgresdb\_backup\_enabled](#input\_postgresdb\_backup\_enabled) | Specifies whether to enable backups for MySQL database. | `bool` | `false` | no |
| <a name="input_postgresdb_restore_config"></a> [postgresdb\_restore\_config](#input\_postgresdb\_restore\_config) | Configuration options for restoring dump to the MySQL database. | `any` | <pre>{<br/>  "bucket_uri": "",<br/>  "file_name": ""<br/>}</pre> | no |
| <a name="input_postgresdb_restore_enabled"></a> [postgresdb\_restore\_enabled](#input\_postgresdb\_restore\_enabled) | Specifies whether to enable restoring dump to the MySQL database. | `bool` | `false` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Specifies whether the RDS instance is publicly accessible over the internet | `bool` | `false` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | The length of the randomly generated password for the RDS primary cluster (default: 16) | `number` | `16` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number of replica instance | `number` | `1` | no |
| <a name="input_replica_enable"></a> [replica\_enable](#input\_replica\_enable) | Whether enable replica DB | `bool` | `false` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a replicate database, and uses the specified value as the source database identifier | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If set to true, no DB snapshot is created. If set to false, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | The Slack channel where notifications will be posted. | `string` | `""` | no |
| <a name="input_slack_notification_enabled"></a> [slack\_notification\_enabled](#input\_slack\_notification\_enabled) | Whether to enable/disable slack notification. | `bool` | `false` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | The username to use when sending notifications to Slack. | `string` | `""` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | The Slack Webhook URL where notifications will be sent. | `string` | `""` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether to create the database from a snapshot. Use the snapshot ID found in the RDS console, e.g., rds:production-2015-06-26-06-05 | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether to enable database encryption | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | The storage type for the database storage like gp2,gp3,io1 | `string` | `"gp2"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs used by the database subnet group | `list(any)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the RDS cluster will be deployed | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | Connection endpoint of the RDS instance. |
| <a name="output_db_instance_name"></a> [db\_instance\_name](#output\_db\_instance\_name) | Name of the database instance |
| <a name="output_db_instance_password"></a> [db\_instance\_password](#output\_db\_instance\_password) | Password for accessing the database. |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | Master username for accessing the database. |
| <a name="output_db_parameter_group_id"></a> [db\_parameter\_group\_id](#output\_db\_parameter\_group\_id) | ID of the parameter group associated with the RDS instance. |
| <a name="output_db_subnet_group_id"></a> [db\_subnet\_group\_id](#output\_db\_subnet\_group\_id) | ID of the subnet group associated with the RDS instance. |
| <a name="output_master_credential_secret_arn"></a> [master\_credential\_secret\_arn](#output\_master\_credential\_secret\_arn) | The ARN of the master user secret (Only available when manage\_master\_user\_password is set to true) |
| <a name="output_rds_dedicated_security_group"></a> [rds\_dedicated\_security\_group](#output\_rds\_dedicated\_security\_group) | ID of the security group associated with the RDS instance. |
| <a name="output_replica_db_instance_endpoint"></a> [replica\_db\_instance\_endpoint](#output\_replica\_db\_instance\_endpoint) | Connection endpoint of the RDS instance. |
| <a name="output_replica_db_instance_name"></a> [replica\_db\_instance\_name](#output\_replica\_db\_instance\_name) | Name of the replica database s |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribute & Issue Report

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-rds-postgresql/issues) on GitHub
  2. Search to check if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Make sure to provide enough context and details.

## License

Apache License, Version 2.0, January 2004 (https://www.apache.org/licenses/LICENSE-2.0)

## Support Us

To support our GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-aws-rds-postgresql)

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Staring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
