#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

cp mango.repo /etc/yum.repos.d/mango.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y 

VALIDATE $? "installing mangodb" &>> $LOGFILE

systemctl enable mongod

VALIDATE $? "enabling mangodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "starting mangodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "remote access to mangodb"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restarting mangodb"
