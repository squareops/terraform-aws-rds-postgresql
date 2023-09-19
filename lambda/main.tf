resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.cwl_retention_days
  tags              = var.tags
}

resource "aws_lambda_function" "this" {
  function_name    = var.name
  description      = var.description
  filename         = var.artifact_file
  source_code_hash = var.artifact_file != null ? filebase64sha256(var.artifact_file) : null
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout

  dynamic "environment" {
    for_each = (length(var.environment) > 0 ? [1] : [])
    content {
      variables = var.environment
    }
  }

  tags = var.tags
}
