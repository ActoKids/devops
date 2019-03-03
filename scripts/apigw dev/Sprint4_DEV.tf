###   Sprint 4 Tasks                               ###
###   By Lyndon Pereira                            ###
###   https://github.com/ActoKids/devops/issues/29 ###

# 1) Create CNAME in Route53
resource "aws_route53_record" "cname_route53_record" {
  zone_id = "Z2LPYP78RENDKO"                                     # Replace with your zone ID
  name    = "api-dev.greyarea.link"                              # Replace with your name/domain/subdomain
  type    = "CNAME"
  ttl     = "300"
  records = ["d-jangmup4fd.execute-api.us-west-2.amazonaws.com"]
}
# 2) Configure API GW to use the CNAME + SSL certificate
resource "aws_api_gateway_domain_name" "greyarea" {              # Bind the SSL Cert to the Dev Environment Domain
  regional_certificate_arn = "arn:aws:acm:us-east-1:083406710909:certificate/125d48b4-646c-455a-bd48-d3582362cbb5"
  domain_name              = "dev-api.greyarea.link"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
# 3) Configure the API Gateway to point to Lambda for CNAME
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda.zip"
}
resource "aws_lambda_function" "ak-api-dev-lambda" {             # Lambda function for Dev Environment
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "ak-api-dev-lambda"
  role             = "${aws_iam_role.lambda_api_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish          = true
}
resource "aws_iam_role" "lambda_api_role" {                      # Lambda role for Dev Environment
  name               = "lambda_api_role"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}
resource "aws_api_gateway_rest_api" "events_api" {               # Instantiates the Dev API Gateway (REST API)
  name        = "ak-api-dev-gateway"
  description = "Events Rest Api for the Dev Environment"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "events_api_resource" {      # Instantiates an APIGW resource to represent the /events endpoint
  rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.events_api.root_resource_id}"
  path_part   = "events"
}
resource "aws_api_gateway_method" "events_api_method" {          # Instantiates a method to handle GET
  rest_api_id   = "${aws_api_gateway_rest_api.events_api.id}"
  resource_id   = "${aws_api_gateway_resource.events_api_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}


##  Uncomment below to use for Dev Environment.         ##
##  Developer of API Gateway needs to add their input   ##


# resource "aws_api_gateway_integration" "events_api_method-integration" { # Instantiates APIGW integration between the api and lambda function
#   rest_api_id = "${aws_api_gateway_rest_api.api.id}"
#   resource_id = "${aws_api_gateway_resource.resource.id}"
#   http_method = "${aws_api_gateway_method.method.http_method}"
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   uri                     = "http://api-dev.greyarea.link/{proxy}"
 
#   request_parameters =  {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
# }
# resource "aws_api_gateway_integration" "events_api_method-integration" {  # Instantiates APIGW integration between the api and lambda function
#   rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
#   resource_id = "${aws_api_gateway_resource.events_api_resource.id}"
#   http_method = "${aws_api_gateway_method.events_api_method.http_method}"
#   type = "AWS_PROXY"
#   #The URI at which the API is invoked
#   uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${aws_lambda_function.events_test_function.function_name}/invocations"
#   integration_http_method = "GET"
# }
# resource "aws_api_gateway_method_response" "lambda-api-method-response" {  # Create an HTTP method response for the aws lambda integration
#   rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
#   resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"
#   http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"
#   status_code = "200"
# }
# resource "aws_api_gateway_integration_response" "lambda-api-integration-response" {  # Configure the API Gateway and Lambda functions response
#   rest_api_id = "${aws_api_gateway_rest_api.roman-numeral-api.id}"
#   resource_id = "${aws_api_gateway_resource.integer-api-resource.id}"
#   http_method = "${aws_api_gateway_method.integer-to-roman-numeral-method.http_method}"

#   status_code = "${aws_api_gateway_method_response.lambda-api-method-response.status_code}"

#   # Configure the Velocity response template for the application/json MIME type
#   response_templates {
#     "application/json" = "${file("response.vm")}"
#   }

#   # Remove race condition where the integration response is built before the lambda integration
#   depends_on = [
#     "aws_api_gateway_integration.lambda-api-integration"
#   ]
# }
# resource "aws_api_gateway_deployment" "events_deployment_dev" {  # Instantiates a deployment stage to the Dev Environment
#   depends_on = [
#     "aws_api_gateway_method.events_api_method",
#     "aws_api_gateway_integration.events_api_method-integration"
#   ]
#   rest_api_id = "${aws_api_gateway_rest_api.events_api.id}"
#   stage_name = "dev"
# }
# output "dev_url" {                                               # Produces an output variable for Dev API URL
#   value = "https://${aws_api_gateway_deployment.events_deployment_dev.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.events_deployment_dev.stage_name}"
# }



# 4) Want to test it out ? 
#    curl -X GET -H "Content-Type: application/json" "DEV_URL"