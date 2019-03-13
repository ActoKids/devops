###   Sprint 5 Tasks                               ###
###   By Lyndon Pereira                            ###
###   https://github.com/ActoKids/devops/issues/49 ###

# 1) Create CloudWatch logs that monitor the Lambda Crawler
resource "aws_iam_role" "eventwatch_exec_role" {                            ## Provides an IAM role.
        name = "eventwatch_exec_role"
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
data "aws_iam_policy_document" "eventwatch_s3_full_doc" {                  ## Generates an IAM policy document in JSON format.
    statement {
        actions = [
            "s3:*",
        ]   
        resources = [
            "arn:aws:s3:::*",
        ]   
    }   
}
resource "aws_iam_policy" "eventwatch_s3_full" {                           ## Provides an IAM policy.
    name = "eventwatch_s3_full"
    path = "/"
    policy = "${data.aws_iam_policy_document.eventwatch_s3_full_doc.json}"
}
resource "aws_iam_role_policy_attachment" "eventwatch_s3_policy_attach" {
    role       = "${aws_iam_role.eventwatch_exec_role.name}"
    policy_arn = "${aws_iam_policy.eventwatch_s3_full.arn}"
}

resource "aws_lambda_function" "eventwatch_lambda" {                     ## Attaches a Managed IAM Policy to an IAM role
        function_name = "eventwatch"
        handler = "lambda_function.lambda_handler"
        runtime = "python2.7"
        filename = "../eventwatch.zip"
        source_code_hash = "${base64sha256(file("eventwatch.zip"))}"
        role = "${aws_iam_role.eventwatch_exec_role.arn}"
        timeout = 15
}
resource "aws_lambda_permission" "allow_cloudwatch_ec2_events" {       ## Creates a Lambda permission to allow external sources invoking the Lambda function (e.g. CloudWatch Event Rule, SNS or S3).
  statement_id   = "AllowExecutionFromCloudWatch2"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.eventwatch_lambda.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.ec2_events.arn}"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch-sumologic-lambda-subscription" {   ## Provides a CloudWatch Logs subscription filter resource.
  name            = "cloudwatch-sumologic-lambda-subscription" 
  role_arn        = "${aws_iam_role.jordi-waf-cloudwatch-lambda-role.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.jordi-waf-int-app-loggroup.name}"
  filter_pattern  = "logtype test"
  destination_arn = "${aws_lambda_function.cloudwatch-sumologic-lambda.arn}"
}