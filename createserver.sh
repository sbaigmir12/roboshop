#!/bin/bash
NAMES=("webapp")
INSTANCE_TYPE=""
IMAGE_ID=ami-0f5491949718e94f6
SECURITY_ID=sg-0fdaea7c119e6a3f8 

for i in ""${NAMES[@]}"
do
	if [ [ i == "mongodb" || $i == "mysql" ]];
	then
	   INSTANCE_TYPE=t3.medium
    else
	   INSTANCE_TYPE=t2.micro
    fi
	echo "creating $i instance"
	IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"
done







