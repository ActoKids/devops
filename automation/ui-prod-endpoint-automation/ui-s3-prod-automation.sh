#!/bin/sh
#aws cloudfront create-distribution --cli-input-json file://create-distribution-cloudfront.json
aws route53 change-resource-record-sets --hosted-zone-id Z3OK8WXAZJPC8H --change-batch file://upsert-record-r53.json

