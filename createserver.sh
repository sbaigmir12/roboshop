#!/bin/bash
NAMES=("myapp" "webapp")
INSTANCE_TYPE=""
IMAGE_ID=ami-0f5491949718e94f6
SECURITY_GP_ID=sg-0fdaea7c119e6a3f8 
DOMAIN_NAME= 

for i in "${NAMES[@]}"
do
	if [[ $i == mysql || $i == mongodb]]
	then
	   INSTANCE_TYPE="t3.medium"
    else
	    INSTANCE_TYPE="t2.medium"
    fi
	echo "create $i $INSTANCE_TYPE"
	IP_ADDRESS=(aws ec2 run-instances --image-id "ami-0f5491949718e94f6"  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
	echo "create $i: $IP_ADDRESS"

	aws route53 change-resource-record-sets --hosted-zone-id Z0820216GGA7ME4W82MS --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '

done






