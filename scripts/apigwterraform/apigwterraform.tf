#terraform resource for {API GW resource} in aws
########### run-DeleMessagesById ###########
resource "aws_api_gateway_resource" "run-delete-messages-by-id" {
  rest_api_id = "${var.REST_API_ID}"
  parent_id   = "${var.PARENT_ID}"
  path_part   = "run-delete-messages-by-id"
}


#terraform resource for {API GW REST API} in aws
data "aws_api_gateway_rest_api" "ad440_rest_api_gw" {
  name = "ad440-rest-api-gw"
}
