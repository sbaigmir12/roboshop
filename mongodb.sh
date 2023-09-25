DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp
LOGFILE=$LOGDIR/$DATE-$SCRIPT_NAME.log

R="\e[31m"
G="\e[32m"

USERID=$(id -u)
if [  $USERID -ne 0 ];
then
   echo "user must have root access"
   exit 1
fi

VALIDATE(){
   if [ $1 -ne 0 ];
   then
      echo -e "$2 is failure $R"
   else
      echo -e "$2 is installed $G"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "cp mongo.repo to etc folder"

yum install mongodb-org -y   &>> $LOGFILE
VALIDATE $? "install mongodb-org"

systemctl enable mongod   &>> $LOGFILE
VALIDATE $? "enable mongodb"

systemctl start mongod  &>> $LOGFILE
VALIDATE $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "replace ip"

systemctl restart mongod  &>> $LOGFILE
VALIDATE $? "RESTART MONGOD"
