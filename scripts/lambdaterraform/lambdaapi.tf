# terraform devops/script/lambdaterrraform/lamdbaapi.tf
# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that calls a API lambda function, api_development.
resource "aws_lambda_function" "api_development" {
    function_name = "api_development"
    runtime = "nodejs8.10"
    filename = "index.js"
    handler = "index.handler"
    description = "API test function"
    role = "${aws_iam_role.lambda_exec_role.arn}"
}
