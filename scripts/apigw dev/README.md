## Sprint 4

- Create CNAME in Route53
- Configure API GW to use the CNAME + SSL certificate
- Configure the API Gateway to point to Lambda

## Getting Started

To complete this task, I used the references above which talks about instantiating an API Gateway and binding both certificates and Lambda functions to it. The Lambda function itself uses the Dev function created by @ZakBrinlee. 

### Prerequisites

AWS CLI
AWC Credentials Configured
Hashicorp Terraform
IDE (VSCode)

### Installing

1. Clone this repo (git clone)
2. Ensure AWS Creds are configured (aws configure)
3. Initialize Terraform (terraform init)
4. Verify plan (terraform plan)
5. Apply plan to your AWS account (aws apply) 


## Running the tests

After the command "terraform apply" check your AWS console for the following:
  - A new CNAME record in Route53
  - A newly configured API Gateway Using the CNAME + SSL certificate
  - And configured is the API Gateway pointing at Lambda funtion getEventById.js (lambda.zip)

## Deployment

#These methods need to be configured PER ENVIRONMENT:
aws_api_gateway_integration
aws_api_gateway_integration_response
aws_api_gateway_deployment


# 4) Want to test it out ? 
#    curl -X GET -H "Content-Type: application/json" "DEV_URL"