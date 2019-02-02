#terraform resource for {role} in aws
resource "aws_iam_role" "iam_role_for_api_team" {
  name = "iam_role_for_api_team"
  description = "IAM role for DeleteMessageById lambda function (DeleteItem under DynamoDB)"

  assume_role_policy = <<EOF
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
EOF
}

#terraform resource for {policy} in aws
resource "aws_iam_policy" "iam_policy_for_api_team" {
  name = "iam_policy_for_api_team"
  path = "/"
  description = "IAM policy for logging from a lambda function (DeleteMessageById)"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

#terraform resource for {lambda function} in aws
resource "aws_lambda_function" "DeleteMessageById" {
  filename         = "lambda_function_payload.zip"
  function_name    = "DeleteMessageById"
  role             = "${aws_iam_role.iam_role_for_api_team.arn}"
  handler          = "exports.test"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "nodejs8.10"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
