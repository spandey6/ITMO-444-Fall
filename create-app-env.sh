#!/bin/bash

#Create db instances 
aws rds create-db-instance --db-instance-identifier ITMO444-mysqldb-sudu --allocated-storage 10 --db-instance-class db.t2.micro --engine mysql --master-username user --master-user-password userpass

db_instance='aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier''
echo "Your database instance id is: "$db_instance

aws rds wait db-instance-available --db-instance-identifier $db_instance

#creting sns topic
aws sns create-topic --name sudu
echo "sns topic created"

#Subscribing sns topic
aws sns subscribe --topic-arn arn:aws:sns:us-west-2:839071323477:sudu:c89d079f-8588-4a75-b6b1-4ebe59e2c305 --protocol email --notification-endpoint spandey6@hawk.iit.edu

#Create sqs queue
aws sqs create-queue --queue-name ITMO444 --attribites file://create-queue.json

#Create S3 buckets
aws s3 mb s3://raw-spd
aws s3 mb s3://finished-spd
aws cp --acl public-read switchonarex.png s3://raw-spd
