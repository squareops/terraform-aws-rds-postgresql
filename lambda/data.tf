# Lambda Assume Role policy
data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    sid    = "LambdaExecRolePolicy"
    effect = "Allow"
    principals {
      identifiers = [
        "lambda.amazonaws.com",
      ]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

# Lambda CloudWatch Logs access
data "aws_iam_policy_document" "lambda_cwl_access" {
  statement {
    sid    = "LambdaCreateCloudWatchLogGroup"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"
    ]
  }
}
