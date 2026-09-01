# AWS Provider Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key (for LocalStack testing)"
  type        = string
  default     = "test"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key (for LocalStack testing)"
  type        = string
  default     = "test"
  sensitive   = true
}

variable "skip_credentials_validation" {
  description = "Skip AWS credentials validation (for LocalStack)"
  type        = bool
  default     = true
}

variable "skip_metadata_api_check" {
  description = "Skip metadata API check (for LocalStack)"
  type        = bool
  default     = true
}

variable "skip_requesting_account_id" {
  description = "Skip requesting AWS account ID (for LocalStack)"
  type        = bool
  default     = true
}

variable "s3_use_path_style" {
  description = "Use path-style S3 URLs (for LocalStack)"
  type        = bool
  default     = true
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
  default     = "http://localhost:4566"
}

# Application Configuration
variable "api_key" {
  description = "API key for backend authentication (NEVER commit this - use terraform.tfvars or environment variables)"
  type        = string
  sensitive   = true
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
  default     = "sre-backend-lambda"
}

variable "api_name" {
  description = "API Gateway name"
  type        = string
  default     = "sre-http-api"
}

variable "lambda_zip_path" {
  description = "Path to Lambda function ZIP file"
  type        = string
  default     = "../backend/lambda.zip"
}
