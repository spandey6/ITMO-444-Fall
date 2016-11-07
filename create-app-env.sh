#!/bin/bash

#Create db instances 
aws rds create-db-instance --db-instance-identifier ITMO444-mysqldb-sudu --allocated-storage 10 --db-instance-class db.t2.micro --engine mysql --master-username user --master-user-password userpass
db-id-for-instance='aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier''
echo "Your database instance id is: "$db-id-for-instance

aws rds wait db-instance-available --db-instance-identifier $db-id-for-instance

#creting sns topic
aws sns create-topic --name sudu
echo "sns topic created"

#Subscribing sns topic
aws sns subscribe --topic -arn  --protocol sms --notification-endpoint 7735171580

#Create sqs queus
aws sqs create-queue --queue-name ITMO444 --attribites file://create-queue.text

#delete db instances
#aws rds delete-db-instance --skip-final-snapshot --db-instance-identifier $db-id-for-instance
#aws rds wait db-instance-deleted --db-instance-identifier $db-id-for-instance
#echo "Database deleted"
