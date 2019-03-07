deveops/scripts/lambdaterraform/variables.tf

# Terraform Variables
variable "access_key" {}
variable "secret_key" {}

# the variable sets the runtime and defaults it to US-East-1
variable "region" {
    default = "us-east-1"
}
variable "function_name" {
    type = "string"
}
variable "file_name" {
  default = "lambda_function.zip"
}
variable "runtime" {
    type = "string"
}
# the variable sets the handler and defaults it to lambda.handler
variable "handler" {
  default = "lambda.handler"
}
variable "environment" {
    type = "string"
}
variable "team" {
    type = "string"
}
