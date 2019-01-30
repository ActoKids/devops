# terraform/variables.tf

# required for AWS
variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-west-1"
}

# specific to our site
variable "root_domain" {
    default = "test.com"
}

variable "bucket_subdomain" {
    default = "s3terraform"
}

variable "public_subdomain" {
    default = "demo"
}