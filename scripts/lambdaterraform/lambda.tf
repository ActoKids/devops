# terraform devops/script/lambdaterrraform/lamdba.tf
# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# terraform that calls a API lambda function, api_development.
variable "api_development" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  api_development = "${var.api_development}"
}

# terraform that calls a crawler lambda function, crawler_development.
variable "crawler_development" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  crawler_development = "${var.crawler_development}"
}
