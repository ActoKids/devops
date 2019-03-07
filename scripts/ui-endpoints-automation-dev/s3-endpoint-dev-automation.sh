#run the configuration for aws credentials
aws configure
#creates a route53 record set for www-dev.2edusite.com
aws route53 change-resource-record-sets --hosted-zone-id Z254GRV0BIP8AH --change-batch '
{
            "Comment": "UPSERT a record for the hosted zone www-dev.2edusite.com",
            "Changes": [{
            "Action": "UPSERT",
                        "ResourceRecordSet": {
                                    "Name": "www-dev.2edusite.com",
                                    "Type": "A",
				    "AliasTarget":{
					    "HostedZoneId": "Z2O1EMRO9K5GLX",
					    "DNSName": "s3-website.us-east-2.amazonaws.com",
					    "EvaluateTargetHealth": false
				    }
}
	    }]
}'
