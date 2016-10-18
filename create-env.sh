#!/bin/bash

if [$# != 5];
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
#ami id=ami-06b94666=$1
#keyname=spandey=$2
#securitygroup=sg-0e14c377=$3
#launchconfiguration=ITMO-444-hw4=$4
#count=$5
echo "All the parameters are preseent."
fi
#VPCID= '(aws ec2 create-vpc -- cidr-block 10.0.0.0/28 --output=text | ('print $6')')

#aws ec2 run-instances --image-id $1 --key-name $2 --security-group-ids $3 --instance-type t2.micro --client-token current-running-instances --user-data file://installenv.sh --count 5

#ID=`aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,ClientToken]' | grep current-running-instances | awk '{print $1}'`

#Create Load balancer
#aws ec2 run-instances --image-id ami-06b94666 --key-name spandey --security-group-ids sg-0e14c377 --instance-type t2.micro --user-data file://installenv.sh --placement AvailabilityZone=us-west-2b --count $5

aws elb create-load-balancer --load-balancer-name ITMO-444-sudu --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnets subnet-a8dcaede
echo "Load Balancer is Created"

#aws elb register-instances-with-load-balancer --load-balancer-name ITMO-444-sudu --instances $ID

# Creating autoscaling launch configuration
aws autoscaling create-launch-configuration --launch-configuration-name $4 --image-id $1 --key-name $2 --security-groups $3 --instance-type t2.micro --user-data file://installenv.sh
echo "Launch configuration is created."

# Creating autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name ITMO444-hw4 --launch-configuration ITMO444 --availability-zone us-west-2b --load-balancer-name ITMO-444-sudu --max-size 5 --min-size 1 --desired-capacity $1
echo "Auto-scaling group is created."

# Attaching the load balancer to the group
#aws autoscaling attach-load-balancers --load-balancer-names ITMO-444-sudu --auto-scaling-group-name ITMO444-hw4
echo "Done"
