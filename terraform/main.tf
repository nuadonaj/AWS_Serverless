terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    lambda        = "http://localhost:4566"
    apigateway    = "http://localhost:4566"
  }
}

resource "aws_lambda_function" "backend" {
  function_name = "sre-backend-lambda"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"

  filename         = "../backend/lambda.zip"
  source_code_hash = filebase64sha256("../backend/lambda.zip")

  role = "arn:aws:iam::000000000000:role/lambda-execution-role"
}

resource "aws_api_gateway_rest_api" "http_api" {
  name = "sre-http-api"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id
  parent_id   = aws_api_gateway_rest_api.http_api.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "get_lambda" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.get_lambda.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.backend.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_stage" "default_stage" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "default"
}

resource "aws_api_gateway_api_key" "my_key" {
  name  = "sre-key"
  value = "ax66832737484473837478483278434898242134"
}

output "api_url" {
  value = "http://${aws_api_gateway_rest_api.http_api.id}.execute-api.localhost.localstack.cloud:4566/default/lambda"
}
