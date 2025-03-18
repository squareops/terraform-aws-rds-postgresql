## PostgreSQL Example
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>

This example will be very useful for users who are new to a module and want to quickly learn how to use it. By reviewing the examples, users can gain a better understanding of how the module works, what features it supports, and how to customize it to their specific needs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 1.0 |
| <a name="module_rds-pg"></a> [rds-pg](#module\_rds-pg) | squareops/rds-postgresql/aws | 2.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | squareops/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | Database name |
| <a name="output_instance_endpoint"></a> [instance\_endpoint](#output\_instance\_endpoint) | Connection endpoint of the RDS instance. |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | Name of the database instance. |
| <a name="output_instance_password"></a> [instance\_password](#output\_instance\_password) | Password for accessing the database (Note: Terraform does not track this password after initial creation). |
| <a name="output_instance_username"></a> [instance\_username](#output\_instance\_username) | Master username for accessing the database. |
| <a name="output_master_user_secret_arn"></a> [master\_user\_secret\_arn](#output\_master\_user\_secret\_arn) | n/a |
| <a name="output_parameter_group_id"></a> [parameter\_group\_id](#output\_parameter\_group\_id) | ID of the parameter group associated with the RDS instance. |
| <a name="output_rds-mysql_replica_db_instance_name"></a> [rds-mysql\_replica\_db\_instance\_name](#output\_rds-mysql\_replica\_db\_instance\_name) | The name of the database instance |
| <a name="output_replica_instances_endpoints"></a> [replica\_instances\_endpoints](#output\_replica\_instances\_endpoints) | Connection endpoint of the RDS replica instances. |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | ID of the security group associated with the RDS instance. |
| <a name="output_subnet_group_id"></a> [subnet\_group\_id](#output\_subnet\_group\_id) | ID of the subnet group associated with the RDS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
