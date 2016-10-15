#!/bin/bash

if [ $# != 5 ]
then
echo "There are less than 5 parameters AMI ID, key-name, security-group, launch configuration, and count."
 else
amiid=$1
keyname=$2
securitygroup=$3
launchconfiguration=$4
count=$5

#Create Load balancer
subnet = aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'

aws ec2 run-instances --image-id $1 --key-name $2 --security-group-ids $3 --client-token sudu --instance-type t2.micro --user-data file://installapp.sh --placement AvailabilityZone=us-west-2b --count $5

aws elb create-load-balancer --load-balancer-name ITMO-444-sudu --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnet $subnet --security-groups $3
echo "Load Balancer is Created"

# Creating autoscaling launch configuration
aws autoscaling create-launch-configuration --launch-configuration-name $4 --image-id $amiid --security-groups $3 --key-name $2 --instance-type t2.micro --user-data file://installenv.sh
echo "Launch configuration is created."

# Creating autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name ITMO444-hw4 --launch-configuration $4 --availability-zone us-west-2b --load-balancer-name ITMO-444-sudu --max-size 5 --min-size 2 --desired-capacity $5
echo "Auto-scaling group is created."

# Attaching the load balancer to the group
aws autoscaling attach-load-balancers --load-balancer-names ITMO-444-sudu --auto-scaling-group-name ITMO444-hw4
echo "Done"
fi
