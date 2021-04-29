data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "src"
  output_path = "archive/mylambda.zip"
}

resource "aws_lambda_function" "example" {
  function_name = "${var.app_name}-example"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.8"

  filename         = data.archive_file.function_source.output_path
  source_code_hash = data.archive_file.function_source.output_base64sha256
}

resource "aws_iam_role" "lambda" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.example.function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda" {
  name        = "${var.app_name}-lambda-policy"
  path        = "/"
  description = "IAM policy for lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "${aws_cloudwatch_log_group.lambda.arn}:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
