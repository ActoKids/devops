# required credential information in AWS
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-east-2"
}
# Terraform Variables
variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-2"
}
variable "www_domain_name" {
  default = "www.2edusite.com"
}
variable "root_domain_name" {
  default = "2edusite.com"
}
variable "environment" {
  type = "string"
}
variable "member" {
  type = "string"
}

resource "aws_s3_bucket" "www" {
  bucket = "${var.www_domain_name}"
  acl    = ""
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.www_domain_name}/*"]
    }
  ]
}
POLICY
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_acm_certificate" "certificate" {
  domain_name   = "www.webui-${var.member}.${var.www_domain_name}"
  validation_method = "DNS"

  tags = {
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    domain_name = "${aws_s3_bucket.www.website_endpoint}"
    origin_id   = "${var.www_domain_name}"
  }

  enabled             = true
  default_root_object = "index.html"

  // Default values from AWS
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.www_domain_name}"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  aliases = ["${var.www_domain_name}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.certificate.arn}"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_zone" "zone" {
  name = "${var.root_domain_name}"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "${var.www_domain_name}"
  type    = "A"

  alias = {
    name                   = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
