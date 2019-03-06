#!/bin/sh
CF_DOMAIN_NAME=$(aws cloudfront create-distribution --cli-input-json file://create-distribution-cloudfront.json --query DomainName --output text)
#F_DOMAIN_NAME=d1mx7lg22jtdst.cloudfront.net
echo $CF_DOMAIN_NAME
aws route53 change-resource-record-sets --hosted-zone-id Z3OK8WXAZJPC8H --change-batch file://upsert-record-r53.json

