#!/bin/sh
#enviromental variables
ACTO_HOSTED_ZONE_ID=Z254GRV0BIP8AH
#shell/bash script for automating of endpoint creation(2edusite.com and www.2edusite.com)
#configures credentials for aws
aws configure
#creates an cloudfront distribution with attached SSL certificate
aws cloudfront create-distribution --cli-input-json file://create-distribution-cloudfront.json
#creates an or updates existing record set in
aws route53 change-resource-record-sets --hosted-zone-id $ACTO_HOSTED_ZONE_ID --change-batch file://upsert-record-r53.json

