###   Amy Funk  ###
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# Create CNAME in Route53
resource "aws_route53_record" "cname_route53_record" {
  zone_id = "Z254GRV0BIP8AH" 
  name    = "api.2edusite.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["d-4m9hyqv3ah.execute-api.us-west-2.amazonaws.com."]
}
# Configure API Gateway to use the CNAME and SSL Cert
resource "aws_api_gateway_domain_name" "2edusite" {             # Bind the SSL Cert to the Prod Environment Domain
  regional_certificate_arn = "arn:aws:acm:us-east-2:061431082068:certificate/54479a3f-920a-4430-909e-56b253dde657"
  domain_name              = "api.2edusite.com"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
# Configure the API Gateway to point to Lambda for CNAME
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda.zip"
}
resource "aws_lambda_function" "ak-api-prod-lambda" {             # Lambda function for Prod Environment
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "ak-api-prod-lambda"
  role             = "${aws_iam_role.lambda_api_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish          = true
}
resource "aws_iam_role" "lambda_api_role" {                      # Lambda role for Prod Environment
  name               = "lambda_api_role"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}
resource "aws_api_gateway_rest_api" "events_api" {               # Creates the Prod API Gateway
  name        = "ak-travis-api-gateway"
  description = "Events for the Prod Environment"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "events_api_resource" {      # Creates an API Gateway resource to point to the endpoint
  rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.events_api.root_resource_id}"
  path_part   = "events"
}
resource "aws_api_gateway_method" "events_api_method" {          # Creates a method to handle DELETE
  rest_api_id   = "${aws_api_gateway_rest_api.events_api.id}"
  resource_id   = "${aws_api_gateway_resource.events_api_resource.id}"
  http_method   = "DELETE"
  authorization = "NONE"
}

###  Code below needs to be configured per API Gateway   ###

/* resource "aws_api_gateway_integration" "events_api_method-integration" { # Creates API Gateway integration between the API and lambda 
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "https://api.2edusite.com/{proxy}"
 
  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
} */
# resource "aws_api_gateway_integration" "events_api_method-integration" {  # Instantiates APIGW integration between the api and lambda function
#   rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
#   resource_id = "${aws_api_gateway_resource.events_api_resource.id}"
#   http_method = "${aws_api_gateway_method.events_api_method.http_method}"
#   type = "AWS_PROXY"
#   #The URI at which the API is invoked
#   uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${aws_lambda_function.events_test_function.function_name}/invocations"
#   integration_http_method = "GET"
# }
/* 
resource "aws_api_gateway_integration_response" "lambda-api-integration-response" {  # Configure the API Gateway and Lambda functions response
  rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
  resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"
  http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"

  status_code = "${aws_api_gateway_method_response.lambda-api-method-response.status_code}"

  # Configure the Velocity response template for the application/json MIME type
  response_templates {
    "application/json" = "${file("response.vm")}"
  }

  # Remove race condition where the integration response is built before the lambda integration
  depends_on = [
    "aws_api_gateway_integration.lambda-api-integration"
  ]
}

resource "aws_api_gateway_deployment" "events_deployment_prod" {  # Instantiates a deployment stage to the Prod Environment
  depends_on = [
    "aws_api_gateway_method.events_api_method",
    "aws_api_gateway_integration.events_api_method-integration"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
  stage_name = "prod"
}
output "prod_url" {                                               # Produces an output variable for Prod API URL
  value = "https://${aws_api_gateway_deployment.events_deployment_prod.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.events_deployment_prod.stage_name}"
} */


# 4) Want to test it out ? 
#    curl -X GET -H "Content-Type: application/json" "PROD_URL"
