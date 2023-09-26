#!/bin/bash
DATE=$(date)
LOGDIR=/tmp
LOGFILE=/tmp/$SCRIPT_NAME-$DATE
SCRIPT_NAME=$0

USERID=$(id -u)
if [ $USERID -ne 0 ];
then
   echo "user must have root access"
   exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ];
    then
       echo "$2 is failure"
       exit 1
    else
       echo "$2 is installed"
    fi
}

yum install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "python got installed"

useradd roboshop &>> $LOGFILE
VALIDATE $? " user got added"

mkdir /app &>> $LOGFILE
VALIDATE $? "app got created"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip
VALIDATE $? "payment zip"

cd /app  &>> $LOGFILE
VALIDATE $? "cd to app dir"

unzip /tmp/payment.zip
VALIDATE $? "unzip payment app"

pip3.6 install -r requirements.txt
VALIDATE $? "libraries got installed"

cp /home/centos/roboshop/payment.service /etc/systemd/system/payment.service
VALIDATE $? "cp .service to /etc"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable payment
VALIDATE $? "enable payment"

systemctl start payment
VALIDATE $? "start payment"