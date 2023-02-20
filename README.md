# RDS PostgresQL
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
Terraform module which creates RDS resources on AWS.

## Usage Examples
```hcl
module "rds-pg" {
  source  = "gitlab.com/sq-ia/aws/rds-pg.git"
  engine              = "postgres"
  engine_version      = "13"
  instance_class      = "db.m5.large"
  allocated_storage   = "20"
  storage_encrypted   = true
  kms_key_arn         = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  publicly_accessible = false
  replicate_source_db = null
  db_name             = "postgres"
  master_username     = "pguser" 
  port                             = "5432"
  multi_az                         = "false"
  subnet_ids                       = ["subnet-xyz83181b1c69skaf","subnet-xyzb80a737aeaskaf"]
  skip_final_snapshot              = false
  final_snapshot_identifier_prefix = "final"
  maintenance_window               = "Mon:00:00-Mon:03:00"
  backup_window                    = "03:00-06:00"
  backup_retention_period          = 1
  apply_immediately                = true
  random_password_length           = 10
  create_random_password           = true
  allowed_security_groups  = ["sg-xyz72c1a5f35cskaf"]
  allowed_cidr_blocks      = []
  vpc_id                   = "vpc-xyzb5c1d1b2ecskaf"
  family = "postgres13"
  major_engine_version = "13"
  deletion_protection = true
}
```
Refer [examples](https://github.com/squareops/terraform-aws-rds-pg/tree/main/examples/complete) for more details.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.43.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | ~> 3.0 |
| <a name="module_security_group_rds"></a> [security\_group\_rds](#module\_security\_group\_rds) | terraform-aws-modules/security-group/aws | ~> 4 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.cidr_ingress](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_ingress](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.43.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags for resources | `map(string)` | <pre>{<br>  "automation": "true"<br>}</pre> | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Database storage capacity | `number` | `20` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `list(any)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group ID's to allow access to | `list(any)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `null` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | When to perform DB backups | `string` | `""` | no |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | Whether to create random password for RDS primary cluster | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | create security group or not | `bool` | `true` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Name for an automatically created database on cluster creation | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | provide accidental deletion protection | `bool` | `true` | no |
| <a name="input_enable_ssl_connection"></a> [enable\_ssl\_connection](#input\_enable\_ssl\_connection) | Whether or not to enable the ssl connection | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster. | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The database engine version. Updating this argument results in an outage. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Select enviroment type: dev, demo, prod | `string` | `"demo"` | no |
| <a name="input_family"></a> [family](#input\_family) | Version of mysql DB family being created | `string` | `""` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The name which is prefixed to the final snapshot on cluster destroy | `string` | `"final"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance type | `string` | `"db.m5.large"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | When to perform DB maintenance | `string` | `""` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | The database major engine version. Updating this argument results in an outage. | `string` | `""` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Create username for RDS primary cluster | `string` | `""` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | enable multi AZ for disaster Recovery | `bool` | `false` | no |
| <a name="input_port"></a> [port](#input\_port) | port for database | `number` | `3306` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Publicly accessible to the internet | `bool` | `false` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | (Optional) Length of random password to create. (default: 10) | `number` | `10` | no |
| <a name="input_rds_instance_name"></a> [rds\_instance\_name](#input\_rds\_instance\_name) | RDS instance name | `string` | `"abc"` | no |
| <a name="input_region"></a> [region](#input\_region) | In which region DataBase cluster will create | `string` | `""` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate. | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05. | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Allow Database encryption or not | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs used by database subnet group created | `list(any)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | In which VPC do you want to deploy the RDS cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__1_db_instance_endpoint"></a> [\_1\_db\_instance\_endpoint](#output\_\_1\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output__2_db_instance_name"></a> [\_2\_db\_instance\_name](#output\_\_2\_db\_instance\_name) | The database name |
| <a name="output__3_db_instance_username"></a> [\_3\_db\_instance\_username](#output\_\_3\_db\_instance\_username) | The master username for the database |
| <a name="output__4_db_instance_password"></a> [\_4\_db\_instance\_password](#output\_\_4\_db\_instance\_password) | The database password (this password may be old, because Terraform doesn't track it after initial creation) |
| <a name="output__5_rds_dedicated_security_group"></a> [\_5\_rds\_dedicated\_security\_group](#output\_\_5\_rds\_dedicated\_security\_group) | The security group ID of the cluster |
| <a name="output__6_db_parameter_group_id"></a> [\_6\_db\_parameter\_group\_id](#output\_\_6\_db\_parameter\_group\_id) | The db parameter group id |
| <a name="output__7_db_subnet_group_id"></a> [\_7\_db\_subnet\_group\_id](#output\_\_7\_db\_subnet\_group\_id) | The db subnet group name |
<!-- END_TF_DOCS -->
## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-postgres/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-aws-postgres).

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 4 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

You can find more information about our company on this [squareops.com](https://squareops.com/), follow us on [Linkdin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).

