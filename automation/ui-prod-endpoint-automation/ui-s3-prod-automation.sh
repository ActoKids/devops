#!/bin/sh
#enviromental variables
ACTO_HOSTED_ZONE_ID=Z254GRV0BIP8AH
#shell/bash script for automating of endpoint creation(2edusite.com and www.2edusite.com)
#configures credentials for aws
aws configure
#creates an cloudfront distribution with attached SSL certificate
aws cloudfront create-distribution --cli-input-json '
{
     "DistributionConfig": {
         "Comment": "Creating distribution for 2edusite.com",
         "CacheBehaviors": {
             "Quantity": 0
         }, 
         "Logging": {
             "Bucket": "", 
             "Prefix": "", 
             "Enabled": false, 
             "IncludeCookies": false
         }, 
         "Origins": {
             "Items": [
                 {
                     "OriginPath": "", 
                     "CustomOriginConfig": {
                         "OriginProtocolPolicy": "https-only", 
                         "HTTPPort": 80, 
                         "HTTPSPort": 443
                     }, 
                     "Id": "custom-2edusite.com", 
                     "DomainName": "ak-ui-prod-s3.s3-website.us-east-2.amazonaws.com"
                 }
             ], 
             "Quantity": 1
         }, 
         "DefaultRootObject": "index.html", 
         "PriceClass": "PriceClass_All", 
         "Enabled": true, 
         "DefaultCacheBehavior": {
             "TrustedSigners": {
                 "Enabled": false, 
                 "Quantity": 0
             }, 
             "TargetOriginId": "custom-2edusite.com", 
             "ViewerProtocolPolicy": "redirect-to-https", 
             "ForwardedValues": {
                 "Headers": {
                     "Quantity": 0
                 }, 
                 "Cookies": {
                     "Forward": "none"
                 }, 
                 "QueryString": false
             }, 
             "SmoothStreaming": false, 
             "AllowedMethods": {
                 "Items": [
                   "GET", 
                   "HEAD",
                   "OPTIONS",
                   "PUT",
                   "POST",
                   "PATCH",
                   "DELETE"
                 ], 
                 "CachedMethods": {
                     "Items": [
                         "GET", 
                         "HEAD"
                     ], 
                     "Quantity": 2
                }, 
                 "Quantity": 7
             }, 
             "MinTTL": 0
         }, 
         "CallerReference": "2edusite  distribution 2019-05-03(test)",
         "CustomErrorResponses": {
             "Quantity": 0
         }, 
         "Restrictions": {
             "GeoRestriction": {
                 "RestrictionType": "none", 
                 "Quantity": 0
             }
         }, 
         "Aliases": {
             "Items": [
                 "2edusite.com"
             ], 
             "Quantity": 1
         },
	  "ViewerCertificate": {
		  "CloudFrontDefaultCertificate": false,
          "ACMCertificateArn": "arn:aws:acm:us-east-1:061431082068:certificate/02495bbe-c62b-4ccf-806d-fc7731b8a839", 
		  "CertificateSource": "acm",
          "SSLSupportMethod": "sni-only",
          "MinimumProtocolVersion": "TLSv1.1_2016"}
   }
}'

#creates an or updates existing record set in
aws route53 change-resource-record-sets --hosted-zone-id $ACTO_HOSTED_ZONE_ID --change-batch '
{
            "Comment": "UPSERT a records for the hosted zone 2edusite.com",
            "Changes": [{
            "Action": "UPSERT",
                        "ResourceRecordSet": {
                                    "Name": "2edusite.com",
                                    "Type": "A",
				    "AliasTarget":{
					    "HostedZoneId": "Z2FDTNDATAQYW2",
					    "DNSName": "d39by6usj8vrny.cloudfront.net",
					    "EvaluateTargetHealth": false
				    }
}
	    }, 
	    		{
	    "Action": "UPSERT",
			"ResourceRecordSet": {
		    		   "Name": "www.2edusite.com",
		   		   "Type": "A",
				   "AliasTarget":{
				   	"HostedZoneId": "Z254GRV0BIP8AH",
					"DNSName": "2edusite.com",
					"EvaluateTargetHealth": false
				   }		   
	    }}
	    ]
}'