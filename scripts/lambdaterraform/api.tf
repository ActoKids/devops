variable "api_function" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  api_function = "${var.api_function}"
}
