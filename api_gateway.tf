resource "aws_api_gateway_rest_api" "example" {
  name = "${var.app_name}-api"

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.apigw.id]
  }
}

resource "aws_api_gateway_rest_api_policy" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.example.execution_arn}/*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.example.execution_arn}/*",
      "Condition": {
        "StringNotEquals": {
          "aws:SourceVpce": "${aws_vpc_endpoint.apigw.id}"
        }
      }
    }
  ]
}
EOF
}

data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  path        = "/"
}

resource "aws_api_gateway_method" "get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = data.aws_api_gateway_resource.root.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = data.aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.example.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  stage_description = "setting file hash = ${md5(file("api_gateway.tf"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "dev"
}

