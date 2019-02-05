variable "web_crawler_development" {
  type = "string"
}

data "aws_lambda_function" "existing" {
  webcrawler_function = "${var.web_crawler_development}"
}
