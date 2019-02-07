# terraform that calls a API lambda function, api_development.
resource "aws_lambda_function" "api_development" {
    function_name = "api_development"
    runtime = "nodejs8.10"
    filename = "index.js"
    handler = "index.handler"
    description = "API test function"
    role = "${aws_iam_role.lambda_exec_role.arn}"
}
