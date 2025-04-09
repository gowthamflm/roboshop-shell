#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}
  
if [ ID -ne 0 ]
then
    echo -e "$R ERROR ... Please run the script with root user $N"
    exit 1
else
    echo "you are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disabling nodejs module"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs module" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing nodejs module"

id roboshop
if [$? -ne 0]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE "Adding User"
else
    echo -e "$R User is Already Exit $N...$Y Skipping $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "creating directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading catalogue application"

cd /app

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue"

npm install &>> $LOGFILE

VALIDATE $? "installing dependencies"

cp C:/Users/pavilion/OneDrive/Desktop/gowthamdevops/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue.service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue deamon reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enabling catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "starting catalogue" 

cp C:/Users/pavilion/OneDrive/Desktop/gowthamdevops/catalogue.service  /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mangorepo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "install mangodb-org-shell"

mongo --host mangodb.vengalareddy.site </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading catalogue data in to mangodb"





















