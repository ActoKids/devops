# terraform devops/script/lambdaterrraform/lambda.tf

# a test resource role is created for the lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that creates a Lambda function with environment and tags
resource "aws_lambda_function" "function_name" {
    function_name = "ad440-w19-lambda-${var.team}-${var.function_name}"
    filename = "${var.file_name}"
    runtime  = "${var.runtime}"
    handler  = "${var.handler}"
    source_code_hash = "${base64sha256(file("${var.file_name}"))}"
    role             = "${aws_iam_role.iam_for_lambda.arn}"
    environment {
        variables = {
    Environment  = "${var.environment}"   //DEV, PROD
    }
    }
    tags {
    Name  = "${var.function_name}"        //Function name
    Team  = "${var.team}"                 //API, UI, CRAWLER
    }
}