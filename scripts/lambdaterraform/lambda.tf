# terraform devops/script/lambdaterrraform/lambda.tf
# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that creates a Lambda function
resource "aws_lambda_function" "lambda_development" {
    function_name = "ad440-w19-lambda-${var.team}-${var.function_name}"
    filename = "lambda_function"
    runtime  = "${var.runtime}"
    handler  = "${var.handler}"
    role     = "${var.role}"
    environment {
        variables = {
    Environment  = "${var.environment}"          //DEV, PROD
    Name         = "${var.function_name}"        //Function_name
    Team         = "${var.team}"                 //API, UX, CRAWLER
    }
    }
}
