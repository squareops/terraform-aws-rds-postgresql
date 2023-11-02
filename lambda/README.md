## Lambda for SNS
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>

Here is Lambda that calls the Slack webhook and passes the alarm message as the payload.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_cwl_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_iam_policy_document.lambda_cwl_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_exec_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_file"></a> [artifact\_file](#input\_artifact\_file) | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_cwl_retention_days"></a> [cwl\_retention\_days](#input\_cwl\_retention\_days) | The retention time in days for the CloudWatch Logs Stream. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what the Lambda Function does. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Lambda environment's configuration settings. | `map(string)` | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in the code. | `string` | `"index.handler"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Lambda Function. | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The Runtime used in the Lambda Function. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the module resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `6` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN identifying the Lambda Function. |
| <a name="output_exec_role_id"></a> [exec\_role\_id](#output\_exec\_role\_id) | The ID of the Function's IAM Role. |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN to be used for invoking Lambda Function from API Gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Lambda Function. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
