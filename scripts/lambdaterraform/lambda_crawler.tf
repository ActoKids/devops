# terraform devops/script/lambdaterrraform/lamdba_crawler.tf
# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that calls a crawler lambda function, crawler_development.
resource "aws_lambda_function" "crawler_development" {
    function_name = "crawler_development"
    runtime = "python3.6"
    filename = "index.py"
    handler = "index.handler"
    description = "Crawler test function"
    role = "${aws_iam_role.lambda_exec_role.arn}"
}
