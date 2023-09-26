#!/bin/bash
DATE=$(date)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$DATE-$SCRIPT_NAME
SCRIPT_NAME=$0

USERID=$(id -u)
if [ $USERID -ne 0 ];
then
   echo "user must have root access"
fi

VALIDATE(){
   if [ $1 -ne 0 ];
   then
      echo "$2 is failure"
   else
      echo "$2 is installed"
   fi
}

yum install maven -y
VALIDATE $? "maven got installed"

useradd roboshop
VALIDATE $? "user got added"

mkdir /app
VALIDATE $? "cd to app"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "downlaod shiiping pac"

cd /app
VALIDATE $? "cd to app"

unzip -o /tmp/shipping.zip
VALIDATE $? "unzip shipping fol"

mvn clean package
VALIDATE $? "pom.xml got created"


mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "got moved shi.jar"

cp /home/centos/roboshop/shipping.service  /etc/systemd/system/shipping.service
VALIDATE $? "copied to shipping.service"

systemctl daemon-reload
VALIDATE $? "daemon got reload"

systemctl enable shipping
VALIDATE $? "enable shipping"

systemctl start shipping
VALIDATE $? "start shipping"

yum install mysql -y 
VALIDATE $? "mysql got installed"

mysql -h 172.31.95.69 -uroot -pRoboShop@1 </app/schema/shipping.sql
VALIDATE $? "schema got loaded to mysql db"

systemctl restart shipping
VALIDATE $? "restart ship"
