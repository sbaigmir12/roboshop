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

yum install nodejs -y
VALIDATE $? "nodejs is installed"

useradd roboshop
VALIDATE $? "added roboshop"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "user zip downloaded"

mkdir /app
VALIDATE $? "change to /app directory"
cd /app
VALIDATE $? "cd to app"

unzip /tmp/user.zip
VALIDATE $? "unzip user"


npm install 

VALIDATE $? "npm got installed"

cp user.service /etc/systemd/system/user.service

systemctl daemon-reload 
VALIDATE $? "daemon reload"

systemctl enable user
VALIDATE $? "enable user"

systemctl start user
VALIDATE $? "start user"


