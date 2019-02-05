variable "api_development" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  api_function = "${var.api_development}"
}
