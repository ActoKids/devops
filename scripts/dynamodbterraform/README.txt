Test it out:

1. Install Terraform  - Hashicorp (https://www.hashicorp.com/products/terraform)
2. Install Aws Cli (If not installed already) - (https://aws.amazon.com/cli/)
3. Clone the script (dynamodb.tf & variables.tf) and in your favorite terminal navigate to the dir with the .tf files
4. Run these commands:
    -   aws configure        #enter your aws credentials (key and Id)
    -   terraform -version   #check installation
    -   terraform -init
    -   terraform -apply
5. Check for "Apply complete!" message
6. A DynamoDB table called "messages" is now created in your (us-west-1) region AWS acccount
