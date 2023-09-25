#!/bin/bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=/tmp/$DATE-$SCRIPT_NAME

USERID=$(id -u)
if [ $USERID -ne 0 ];
then
   echo "user must have root access"
fi

VALIDATE(){
	if  [ $1 -ne 0 ]
	then 
	    echo "$2 is failure"
    else
	    echo "$2 is installed"
    fi
}


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "redis installation"

yum module enable redis:remi-6.2 -y
VALIDATE $? "enable redis"

yum install redis -y
VALIDATE $? "install redis"

sed -i ''s/127.0.0.1/0.0.0.0/' /etc/redis.conf/
VALIDATE $? "change ip to 0.0.0.0"


systemctl enable redis
VALIDATE $? "enable redis"

systemctl start redis
VALIDATE $? "start redis"


