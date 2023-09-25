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

yum install nginx -y
VALIDATE $? "nginx install"

systemctl enable nginx
VALIDATE $? "enable nginx"

systemctl start nginx
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "remove html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "downlaod web package from https"

cd /usr/share/nginx/html
VALIDATE $? "change the directory"

unzip /tmp/web.zip
VALIDATE $? "unzip web"

cp roboshop.conf /etc/nginx/default.d/roboshop.conf 
VALIDATE $? "cproboconf to /etc dir"

systemctl restart nginx 
VALIDATE $? "restart nginx"