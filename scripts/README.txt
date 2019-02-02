Test it out:

1. Install Terraform  - Hashicorp (https://www.hashicorp.com/products/terraform)
2. Install Aws Cli (If not installed already) - (https://aws.amazon.com/cli/)
3. Clone the script (dynamodb.tf) and in your favorite terminal navigate to the dir with the .tf file
4. Run these coomands:
    -   aws configure        #enter your aws credentials (key and Id)
    -   terraform -version   #check installation
    -   terraform -init
    -   terraform -apply
5. Check for "Apply complete!" message