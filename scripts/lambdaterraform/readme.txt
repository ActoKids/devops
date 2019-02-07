1. Install Terraform  - Link: https://www.hashicorp.com/products/terraform)
2. Install AWS Cli    - Link: https://aws.amazon.com/cli/
3. Clone the script - variables.tf & lambdacrawler.tf for the crawler and variables.tf & lambdaapi.tf for the API
4. Run these commands:
    -   aws configure        #enter your aws credentials (AWS Access Key and ID)
    -   terraform -version   #check installation
    -   terraform -init
    -   terraform -apply
5. Check for "Apply complete!" message
6. The Lambda functions for the crawler and API are now created in your AWS acccount


(Modified from https://github.com/ActoKids/devops/blob/dev/scripts/dynamodbterraform/README.txt)
