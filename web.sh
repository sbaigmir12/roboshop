#!/bin/bash
DATE=$(date +%F)
SCRIPT_NAME=$(basename "$0")
LOGDIR=/tmp
LOGFILE="$LOGDIR/$DATE-$SCRIPT_NAME.log"

USERID=$(id -u)
if [ $USERID -ne 0 ]; then
   echo "User must have root access"
   exit 1
fi

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo "$2 is a failure"
        exit 1  # Exit the script if a step fails.
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
VALIDATE $? "download web package from https"

cd /usr/share/nginx/html
VALIDATE $? "change the directory"

unzip -o /tmp/web.zip  # Use -o to overwrite existing files without prompting.
VALIDATE $? "unzip web"

cp roboshop.conf /etc/nginx/default.d/roboshop.conf
VALIDATE $? "copy roboshop.conf to /etc/nginx/default.d/"

systemctl restart nginx
VALIDATE $? "restart nginx"

# Log the script's output to the logfile
exec &>> "$LOGFILE"

echo "Script completed successfully."

