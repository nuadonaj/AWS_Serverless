terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  skip_credentials_validation = var.skip_credentials_validation
  skip_metadata_api_check     = var.skip_metadata_api_check
  skip_requesting_account_id  = var.skip_requesting_account_id
  s3_use_path_style           = var.s3_use_path_style

  endpoints {
    lambda     = var.localstack_endpoint
    apigateway = var.localstack_endpoint
  }
}

# Lambda execution role (simplified for LocalStack)
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda function with environment variable for API key
resource "aws_lambda_function" "backend" {
  function_name = "sre-backend-lambda"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "../backend/lambda.zip"
  source_code_hash = filebase64sha256("../backend/lambda.zip")

  # Pass API key as environment variable (not hardcoded in code)
  environment {
    variables = {
      API_KEY = var.api_key
    }
  }
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "http_api" {
  name = "sre-http-api"
}

# Lambda resource
resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id
  parent_id   = aws_api_gateway_rest_api.http_api.root_resource_id
  path_part   = "lambda"
}

# API Key resource (for tracking, actual auth done in Lambda)
resource "aws_api_gateway_api_key" "my_key" {
  name        = "sre-api-key"
  description = "API Key for SRE backend"
  enabled     = true
}

# GET method with API key requirement
resource "aws_api_gateway_method" "get_lambda" {
  rest_api_id      = aws_api_gateway_rest_api.http_api.id
  resource_id      = aws_api_gateway_resource.lambda_resource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

# Lambda integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.http_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.get_lambda.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.backend.invoke_arn
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.http_api.id

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

# Stage
resource "aws_api_gateway_stage" "default_stage" {
  rest_api_id   = aws_api_gateway_rest_api.http_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "default"
}

# Usage plan
resource "aws_api_gateway_usage_plan" "my_usage_plan" {
  name = "sre-usage-plan"
  
  api_stages {
    api_id      = aws_api_gateway_rest_api.http_api.id
    stage       = aws_api_gateway_stage.default_stage.stage_name
  }
}

# Associate API key with usage plan
resource "aws_api_gateway_usage_plan_key" "my_key_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.my_key.id
  usage_plan_id = aws_api_gateway_usage_plan.my_usage_plan.id
  key_type      = "API_KEY"
}

# Outputs
output "api_url" {
  description = "API Gateway endpoint URL"
  value       = "http://${aws_api_gateway_rest_api.http_api.id}.execute-api.localhost.localstack.cloud:4566/default/lambda"
}

output "api_key_id" {
  description = "API Key ID"
  value       = aws_api_gateway_api_key.my_key.id
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.backend.function_name
}
