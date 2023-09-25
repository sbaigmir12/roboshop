#!/bin/bash
SCRIPT_NAME=$0
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE

R="\e[31m"
G="\e[32m"

USERID=(id -u)
if [ $USERID -ne 0 ];
then
   echo "user must have root access"
   exit 1
fi


VALIDATE(){
    if [ $1 -ne 0 ];
    then
       echo "$2 is ....failure"
       exit 1
    else
       echo "$2 is installed"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? " mongo.repo is copied to yum.repos.d/mongo.repo"

yum install mongodb-org -y  &>> $LOGFILE
VALIDATE $? "mongodb org is installed or not"

systemctl enable mongod  &>> $LOGFILE
VALIDATE $? "mongodb is enabled or not"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "mongodb is started"


sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "values got changed"


systemctl restart mongod  &>> $LOGFILE
VALIDATE $? "restart mongod"
