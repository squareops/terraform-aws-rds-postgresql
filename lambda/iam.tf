resource "aws_iam_role" "lambda_exec_role" {
  name               = "${replace(title(var.name), "-", "")}LambdaExecRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_exec_role_policy.json
}

resource "aws_iam_role_policy" "lambda_cwl_policy" {
  name   = "${replace(title(var.name), "-", "")}LambdaCWLogsPolicy"
  role   = aws_iam_role.lambda_exec_role.id
  policy = data.aws_iam_policy_document.lambda_cwl_access.json
}
