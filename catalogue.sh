ID=$(id -u)
$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

TIMESTAMP=$(date +%F-%H_%M_%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE{}{
    if [$1 -ne 0]
    then 
        echo -e "$2 ....$R FAILED $N"
    else
        echo -e "$2 ...  $G SUCESS $N"
    fi        
}
  
if [ID -ne 0]
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

useradd roboshop &>> $LOGFILE

VALIDATE $? "adding user"

mkdir /app &>> $LOGFILE

VALIDATE $? "creating directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue application"

cd /app

unzip /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue"

npm install 

VALIDATE $? "installing dependencies"

cp C:\Users\pavilion\OneDrive\Desktop\gowthamdevops/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "copying catalogue.service file"

systemctl daemon-reload 

VALIDATE $? "catalogue deamon reload"

systemctl enable catalogue

VALIDATE $? "enabling catalogue"

systemctl start catalogue

VALIDATE $? "starting catalogue"

cp C:\Users\pavilion\OneDrive\Desktop\gowthamdevops/mango.repo  /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mangorepo"

dnf install mongodb-org-shell -y

VALIDATE $? "install mangodb-org-shell"

mongo --host mangodb.vengalareddy.site </app/schema/catalogue.js

VALIDATE $? "loading catalogue data in to mangodb"





















