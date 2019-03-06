// Shota Takada
# Sprint4 Part1 - Create route 53 with CNAME
#         Part2 -  Configure API Gateway to use the CNAME + SSL
#         Part3 -  Point API GW to Lambda function  

// Part1
resource "aws_route53_record" "api-1box-route53" {
  zone_id = "${var.zone_id}"
  name    = "api-alexc.2edusite.com" # replace the domain name with your 1 box domain name 
  type    = "CNAME"
  ttl     = "300"
  records = ["d-1cwcvz5gxe.execute-api.us-east-2.amazonaws.com."]
}

# Part2
resource "aws_api_gateway_domain_name" "2edusite" {             # Bind the SSL Cert to the Dev Environment Domain
  regional_certificate_arn = "arn:aws:acm:us-east-1:<REPLACE_WITH_SCHOOL_INFO>:certificate/125d48b4-646c-455a-bd48-d3582362cbb5"
  domain_name              = "api-alexc.2edusite.com"  # replace the domain name with your 1 box domain name 
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Part3
# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "lambda" {
  depends_on = [
    "aws_api_gateway_integration.integration"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.lambda.execution_arn}/*/*"
}

#lambda

resource "aws_lambda_function" "lambda" {
  filename         = "lambda.zip"
  function_name    = "mylambda"
  role             = "${aws_iam_role.role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "nodejs8.10"
}


# IAM
resource "aws_iam_role" "role" {
  name = "myrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}