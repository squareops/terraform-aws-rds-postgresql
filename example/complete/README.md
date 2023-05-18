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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds-pg"></a> [rds-pg](#module\_rds-pg) | git@github.com:sq-ia/terraform-aws-rds-postgresql.git | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_endpoint"></a> [instance\_endpoint](#output\_instance\_endpoint) | Connection endpoint of the RDS instance. |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | Name of the database instance. |
| <a name="output_instance_password"></a> [instance\_password](#output\_instance\_password) | Password for accessing the database (Note: Terraform does not track this password after initial creation). |
| <a name="output_instance_username"></a> [instance\_username](#output\_instance\_username) | Master username for accessing the database. |
| <a name="output_parameter_group_id"></a> [parameter\_group\_id](#output\_parameter\_group\_id) | ID of the parameter group associated with the RDS instance. |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | ID of the security group associated with the RDS instance. |
| <a name="output_subnet_group_id"></a> [subnet\_group\_id](#output\_subnet\_group\_id) | ID of the subnet group associated with the RDS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
