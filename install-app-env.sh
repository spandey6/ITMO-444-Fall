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
#aws sns subscribe --topic -arn  --protocol sms --notification-endpoint 7735171580

#Create sqs queus
#aws sqs create-queue --queue-name ITMO444 --attribites file://create-queue.text

#Create S3 buckets
aws s3api create-bucket --bucket $first_bucket --region us-west-2b
aws s3api create-bucket --bucket $second_bucket --region us-west-2b
