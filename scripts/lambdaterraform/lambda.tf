# terraform devops/script/lambdaterrraform/lambda.tf
# Terraform Variables
# required for AWS

variable "access_key" {}
variable "secret_key" {}
# the variable sets the runtime and defaults it to US-East-1
variable "region" {
    default = "us-east-1"
}
variable "function_name" {
  type = "string"
}
variable "role" {
    default = "arn:aws:iam::061431082068:role/iam_for_lambda"
}
# the variable determines the runtime and defaults it to python 3.6
variable "runtime" {
    default = "python3.6"
}
variable "handler" {
  default = "lambda.handler"
}
variable "environment" {
    type = "string"
}
variable "team" {
    type = "string"
}

# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that creates a Lambda function
resource "aws_lambda_function" "lambda_development" {
    function_name = "ad440-w19-lambda-${var.team}-${var.function_name}"
    filename = "lambda_function.py"
    runtime  = "${var.runtime}"
    handler  = "${var.handler}"
    role     = "${var.role}"
    environment {
        variables = {
    Environment  = "${var.environment}"          //DEV, PROD
    Name         = "${var.function_name}"        //Function name
    Team         = "${var.team}"                 //API, UX, CRAWLER
    }
}
}
