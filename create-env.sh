#!/bin/bash

if [ $# != 7 ]; then
echo "Parameters are missing"
#echo-n "The parameter should be in a format showen below."
#echo-n "1.AMI ID:ami-ami-1fed4c7f"
#echo-n "2.KEY-NAME:spandey"
#echo-n "3.SECURITY-GROUP: sg-0e14c377"
#echo-n "4.LAUNCH-CONFIGURATION: ITMO-444-hw4"
#echo-n "5.COUNT: Number os instances
exit 0
else
echo "All the parameters are preseent."
fi

# Run instances 
aws ec2 run-instances --image-id $1 --key-name $2 --security-group-ids $3 --instance-type t2.micro --count $1 --user-data file://installenv.sh --placement AvailabilityZone=us-west-2b --iam-instance-profile Name=developer
wait
echo "Instance created"

#Create Load balancer
aws elb create-load-balancer --load-balancer-name $6 --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --availability-zones us-west-2b
echo "Load Balancer is Created"

# Creating autoscaling launch configuration
aws autoscaling create-launch-configuration --launch-configuration-name $4 --image-id $1 --key-name $2 --security-groups $3 --instance-type t2.micro --user-data file://installenv.sh
echo "Launch configuration is created."

# Creating autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name $7 --launch-configuration $4 --availability-zone us-west-2b --load-balancer-name $6 --max-size 5 --min-size 1 --desired-capacity $5
echo "Auto-scaling group is created."
echo "Done"
