#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}



yum install nodejs -y
VALIDATE $? "nodejs is installed"

useradd roboshop
VALIDATE $? "useradd got added"

mkdir /app
VALIDATE $? "dir got created"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "catalogue packge download"


cd /app 

VALIDATE $? "Moving into app directory"

unzip /tmp/catalogue.zip 

VALIDATE $? "unzipping catalogue"

npm install -y 

VALIDATE $? "Installing dependencies"

# give full path of catalogue.service because we are inside /app
cp /home/centos/roboshop/catalogue.service /etc/systemd/system/catalogue.service 

VALIDATE $? "copying catalogue.service"

systemctl daemon-reload 

VALIDATE $? "daemon reload"

systemctl enable catalogue 

VALIDATE $? "Enabling Catalogue"

systemctl start catalogue

VALIDATE $? "Starting Catalogue"

cp /home/centos/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo 

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y 

VALIDATE $? "Installing mongo client"

mongo --host 172.31.81.129  </app/schema/catalogue.js 

VALIDATE $? "loading catalogue data into mongodb"
