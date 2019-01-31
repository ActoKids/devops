variable "webcrawler_function" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  webcrawler_function = "${var.webcrawler_function}"
}
