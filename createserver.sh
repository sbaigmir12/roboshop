#!/bin/bash
NAMES=("my name" "my app")
INSTANCE_TYPE=""
IMAGE_ID=ami-0f5491949718e94f6
SECURITY_GROUP_ID=sg-0fdaea7c119e6a3f8 

for i in "${NAMES[@]}"
do
    if [[ $i == "mysql" || $i == "mongodb" ]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "create $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id "ami-0f5491949718e94f6"  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "create $i  instance $IP_ADDRESS"
    done




