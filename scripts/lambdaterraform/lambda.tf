# terraform devops/script/lambdaterrraform/lamdba.tf
# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-west-2"
}

# terraform that calls a crawler lambda function, crawler_development.
resource "aws_lambda_function" "crawler_development" {
    function_name = "crawler_development"
    runtime = "python3.6"
    filename = "index.py"
    handler = "index.handler"
    description = "Crawler test function"
}

# terraform that calls a API lambda function, api_development.
resource "aws_lambda_function" "api_development" {
    function_name = "api_development"
    runtime = "nodejs8.10"
    filename = "index.js"
    handler = "index.handler"
    description = "API test function"
}
