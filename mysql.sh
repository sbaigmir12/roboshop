#!/bin/bash
DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$DATE-$SCRIPT_NAME

VALIDATE(){
    if [ $2 -ne 0 ]
    then
       echo "$1 is failure"
    else
       echo "$2 is successfuuly installed"
    fi
   }

   USERID=$(id -u)
   if [ $USERID -ne 0 ]
   then
      echo "user must have root access"
   fi

yum module disable mysql -y 
VALIDATE $? "mysql is disable"

cp /home/centos/roboshop/mysql.repo /etc/yum.repos.d/mysql.repo
VALIDATE $? "mysql.repo git copied"

yum install mysql-community-server -y
VALIDATE $? "install mysql"

systemctl enable mysqld
VALIDATE $? "enable mysql"

systemctl start mysql
VALIDATE $? "start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set rootpasswd"

mysql -uroot -pRoboShop@1
VALIDATE $? "roboshop"
