#!/bin/sh
aws cloudfront create-distribution --cli-input-json file://create-distribution-cloudfront.json
aws route53 change-resource-record-sets --hosted-zone-id Z254GRV0BIP8AH --change-batch file://upsert-record-r53.json

