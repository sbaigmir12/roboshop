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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "cart zip downloaded"

cd /app
VALIDATE $? "cd to app"

unzip /tmp/cart.zip
VALIDATE $? "unzip cart"


npm install 

VALIDATE $? "npm got installed"

cp cart.service /etc/systemd/system/cart.service

systemctl daemon-reload 
VALIDATE $? "daemon reload"

systemctl enable cart
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"


