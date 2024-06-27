#!/bin/bash

source ./common.sh

check-root

echo "please enter DB password:"
read -s mysql_root_password


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Install mysql server"

systemctl enable mysqld  &>>$LOGFILE
VALIDATE $? "Enabling  mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting  mysql server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "setting up root password"

# below code will be useful for idempotent nature

mysql -h db.ilam-78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
     VALIDATE $? "MYSQL root password set up"
else
     echo -e "root password is already setup...$Y SKIPPING $N"
fi

