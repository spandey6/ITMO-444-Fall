#!/bin/bash

Id='aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[].InstanceId''
echo "Instance ID: " $Id

load_balancer='aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].LoadBalancerName''
echo "Load Balancer Name: "$load_balancer

autoscaling='aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalinGroupsName''
echo "Auto Scaling Group Name: " $autoscaling

launch_confiuration='aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName''
echo "Launch Confiuragration Name: " $launch_configuration

db_instance=`aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier'`
echo "Database instances id: "$db_instance

bucket='aws s3 ls --query 'Buckets[].Name''
echo "List S3 buckets: " $bucket

# De-register the instances form the load balancer
aws elb deregister-instances-from-load-balancer --load-balancer-name $load_balalncer --instances $Id
echo "De-registring the load balancer please wait....."
echo "Load balancer is de-registered."

# Terminating instances
aws ec2 wait terminate-instances --instance-ids $Id
echo "Instances Terminating please wait......."
aws ec2 wait instance-terminate --instance-ids $Id
echo "Instances terminated"

# Detach autoscaling load balancer
aws autoscaling detach-load-balancers --load-balancer-names $load_balancer --auto-scaling-group-name $autoscaling
echo "Detaching load blalancer please wait......."
echo "Load balancer is detached"

# Deleting autoscaling group
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $autoscaling_group
echo "Deleting auto scaling group please wait........."
echo "Auto scaling group deleted."

# Deleting launch configuration 
aws autoscaling delete-launch-configuration --launch-configuration-name $launch_configuration
echo "Launch configuration deleted."

#Deleting load balancer
aws elb delete-load-balancer --load-balancer-name $load_balancer
echo "Load balancer deleted"

#delete db instances
aws rds delete-db-instance --skip-final-snapshot --db-instance-identifier $db_instance
aws rds wait db-instance-deleted --db-instance-identifier $db_instance
echo "Database deleted"

#delete sns topic
aws sns delete-topic  --topic-arn arn:aws:sns:us-west-2:839071323477:sudu

#Delete S3 buckets
aws s3 rb s3://raw-spd --force
aws s3 rb s3://finished-spd --force
echo "S3 bucket deleted."
echo "Environment destroyed"
