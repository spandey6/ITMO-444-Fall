#!/bin/bash

#Create db instances 
aws rds create-db-instance --db-instance-identifier fp-spn-db --allocated-storage 10 --db-instance-class db.t2.micro --engine mysql --master-username controller --master-user-password letmein --publicly accessible

db_instance='aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier''
echo "Your database instance id is: "$db_instance

aws rds wait db-instance-available --db-instance-identifier $db_instance

#creting sns topic
aws sns create-topic --name sudu
echo "sns topic created"

#Subscribing sns topic
aws sns subscribe --topic-arn arn:aws:sns:us-west-2:839071323477:sudu --protocol email --notification-endpoint spandey6@hawk.iit.edu
aws sns add-lermission --topic-arn arn:aws:sns:us-west-2:839071323477:sudu --label S3notification --aws-accoint-id spandey6@hawk.iit.edu --acount-name Publish
#Create sqs queue
aws sqs create-queue --queue-name ITMO444 --attribites file://create-queue.json

#Create S3 buckets
aws s3 mb s3://raw-spd
aws s3 mb s3://finished-spd
aws cp --acl public-read switchonarex.png s3://raw-spd

#Describe db instances
declare -a dbinstance
DBINSTANCEIN=(`aws rds describe-db-instances --output text | grep ENDPOINT | awk {' print $2'}`)
echo 
