# terraform/variables.tf

# required for AWS
variable "access_key" {}
variable "secret_key" {}
# the variable sets the runtime and defaults it to US-East-1
variable "region" {
    default = "us-east-1"
}
variable "function_name" {
  type = "string"
}
variable "role" {
    default = "arn:aws:iam::061431082068:role/iam_for_lambda"
}
# the variable determines the runtime and defaults it to python 3.6
variable "runtime" {
    default = "python3.6"
}
variable "handler" {
  default = "lambda.handler"
}
variable "environment" {
    type = "string"
}
variable "team" {
    type = "string"
}
