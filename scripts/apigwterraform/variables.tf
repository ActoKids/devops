# terraform/variables.tf

# required for AWS
variable "REST_API_ID" {
  default = "lambda.handler"
}

variable "PARENT_ID" {
  default = "lambda.handler"
}

