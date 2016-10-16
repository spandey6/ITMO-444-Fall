#!/bin/bash

if ["$#" -ne 5];
then
echo "Parameters are missing"
echo-n "The parameter should be in a format showen below."
echo-n "1.AMI ID:ami-06b94666"
echo-n "2.KEY-NAME:spandey"
echo-n "3.SECURITY-GROUP: sg-0e14c377"
echo-n "4.LAUNCH-CONFIGURATION: ITMO-444-hw4"
echo-n "5.COUNT: Number os instances where minimum is 2 and maximum is 5"
exit 0
else
echo "All the parameters are preseent."
amiid=ami-06b94666=$1
keyname=spandey=$2
securitygroup=sg-0e14c377=$3
launchconfiguration=ITMO-444-hw4=$4
count=$5

#VPCID= '(aws ec2 create-vpc -- cidr-block 10.0.0.0/28 --output=text | ('print $6')')

#Create Load balancer
SUBNET = aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'

aws ec2 run-instances --image-id $1 --key-name $2 --security-group-ids $3 --client-token sudu --instance-type t2.micro --user-data file://installenv.sh --placement AvailabilityZone=us-west-2b --count $5

aws elb create-load-balancer --load-balancer-name ITMO-444-sudu --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnet $SUBNET --security-groups $3
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
