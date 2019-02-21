# terraform/dynamodb.tf
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-west-1"
    alias      = "us-west-1"
}

# Terraform instantiating a DynamoDB called Message.
# PK of ID 
# Type {String}
resource "aws_dynamodb_table" "messages" {
  name           = "messages"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "ID"

attribute {
    name = "ID"
    type = "S"
  }
 tags {
    Name         = "${var.name}"        //Table name
    Team         = "${var.teamname}"    //API, UX, CRAWLER
    Environment  = "${var.environment}" //ONEBOX, DEV, PROD
  }
}