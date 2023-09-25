#!/bin/bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$DATE-$SCRIPT_NAME
R="/e[31m"
G="/e[32m]"
USERID=$(id -u)
if [ $USERID -ne 0 ];
then
   else "user must have root access"
   exit 1
fi

VALIDATE(){
	if [ $1 -ne 0 ]
	then 
	   echo "$2 is failure $R"
	   exit 1
    else
	   echo "$2 is success $G"
    fi
}


curl -sL https://rpm.nodesource.com/setup_lts.x | bash
VALIDATE $? "package"

yum install nodejs -y
VALIDATE $? "nodejs is installed"

useradd roboshop
VALIDATE $? "useradd got added"

mkdir /app
VALIDATE $? "dir got created"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "catalogue packge download"

cd /app
VALIDATE "change dir to app"

unzip /tmp/catalogue.zip
VALIDATE "unzip package"


#downloading dependencies
npm install
VALIDATE "download dependencies"

cp catalogue.service /etc/systemd/system/catalogue.service
VALIDATE "copied .service  to /etc folder"

systemctl daemon-reload
VALIDATE $? "reload"

systemctl enable catalogue
VALIDATE $? "enable the catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copied .repo to etc dir"

yum install mongodb-org-shell -y
VALIDATE $? "install mongo-db client"

