# terraform/variables.tf

# required for AWS
variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-west-1"
}
