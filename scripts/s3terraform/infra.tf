# terraform/infra.tf
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

resource "aws_s3_bucket" "demo" {
    bucket = "${var.bucket_subdomain}.${var.root_domain}"

    website {
        index_document = "index.html"
        error_document = "404.html"
    }
    
    tags {
        Name         = "${var.name}"        //Table name
        Team         = "${var.teamname}"    //API, UX, CRAWLER
        Environment  = "${var.environment}" //ONEBOX, DEV, PROD
    }
}
