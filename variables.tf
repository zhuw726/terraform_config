variable "REGION" {
  type = string
  default = "us-east-1"
}

# Lambda
variable "FUNCTION_NAME" {
    type = string
    default = "Lambda-Emailing-SNS"
}
variable "FILE_NAME" {
    type = string
    default = "email-service"
}
# IAM role for Lambda function
variable "LAMBDA_IAM_ROLE_NAME" {
  type = string
  default = "Lambda-Emailing-Role"
}
variable "LAMBDA_IAM_ROLE_NAME_POLICY" {
  type = string
  default = "Lambda-Emailing-Role-Policy"
}

# SNS
variable "TOPIC_NAME" {
  type = string
  default = "new-product-topic"
  
}

variable "SUBSCRIBERS" {
  type = list(string)
  default = [ "xxxx.com" ]
}

# S3 bucket
variable "BUCKET_NAME" {
    type = string
    default = "lambda-emailing-service-000a123213a"
}
variable "TAG_NAME" {
    type = string
    default = "lambda-emailing-service"
}

variable "TAG_ENV" {
  type = string
  default = "dev"
}