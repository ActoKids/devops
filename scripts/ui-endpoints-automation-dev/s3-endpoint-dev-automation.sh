#run the configuration for aws credentials
aws configure
$ACTO_HOSTED_ZONE_ID=Z2O1EMRO9K5GLX
#creates a route53 record set for www-dev.2edusite.com
aws route53 change-resource-record-sets --hosted-zone-id $ACTO_HOSTED_ZONE_ID --change-batch '
{
            "Comment": "UPSERT a record for the hosted zone www-dev.2edusite.com",
            "Changes": [{
            "Action": "UPSERT",
                        "ResourceRecordSet": {
                                    "Name": "www-dev.2edusite.com",
                                    "Type": "A",
				    "AliasTarget":{
					    "HostedZoneId": "Z2O1EMRO9K5GLX",
					    "DNSName": "www-dev.2edusite.com.s3-website.us-east-2.amazonaws.com",
					    "EvaluateTargetHealth": false
				    }
}
	    }]
}'