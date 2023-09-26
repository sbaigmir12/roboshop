#!/bin/bash
DATE=$(date +%F)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$DATE-$SCRIPT_NAME
SCRIPT_NAME=$0

USERID=$ (id -u )
if  [ $USERID -ne 0 ]
then
   echo "user must have root access"
   exit 1
fi

VALIDATE(){
if [ $1 -ne 0 ]
then
   echo "$2 is failure"
   exit 1:
else
   echo "$2 is installed"
fi
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
VALIDATE $? "rabbitmq package"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
VALIDATE $? "rabbitmq is installed"

yum install rabbitmq-server -y 
VALIDATE $? "rabbit mq is installed"

systemctl enable rabbitmq-server
VALIDATE $? "rabbitmq is enabled"

systemctl start rabbitmq-server
VALIDATE $? "rabbitmq started"

rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "user got added"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "passwd got set"