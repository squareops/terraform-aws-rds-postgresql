output "name" {
  description = "The name of the Lambda Function."
  value       = aws_lambda_function.this.function_name
}

output "arn" {
  description = "The ARN identifying the Lambda Function."
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway."
  value       = aws_lambda_function.this.invoke_arn
}

output "exec_role_id" {
  description = "The ID of the Function's IAM Role."
  value       = aws_iam_role.lambda_exec_role.id
}
