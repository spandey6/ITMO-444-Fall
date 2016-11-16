#!/bin/bash

if [ $# != 6 ]; then
echo "Parameters are missing"
#echo "The parameter should be in a format showen below."
#echo "1.AMI ID:ami-ami-1fed4c7f"
#echo "2.KEY-NAME:spandey"
#echo "3.SECURITY-GROUP: sg-0e14c377"
#echo "4.LAUNCH-CONFIGURATION: ITMO-444-hw4"
#echo "5.COUNT: Number os instances"
#echo "6. Load Balancer name"
exit 0
else
echo "All the parameters are preseent."
fi

# Run instances 
aws ec2 run-instances --image-id $ami_id --key-name $key_name --security-group-ids $security_group --instance-type t2.micro --count $1 --user-data file://installenv.sh --placement AvailabilityZone=us-west-2b --iam-instance-profile Name=developer
echo "Instance created"

#Create Load balancer
aws elb create-load-balancer --load-balancer-name $load_balancer --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --availability-zones us-west-2b
echo "Load Balancer is Created"

# Creating autoscaling launch configuration
aws autoscaling create-launch-configuration --launch-configuration-name $launch_configuration --image-id $ami_id --key-name $key_name --security-groups $security_group --instance-type t2.micro --user-data file://installenv.sh
echo "Launch configuration is created."

# Creating autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name $autoscaling --launch-configuration $launch_configuration --availability-zone us-west-2b --load-balancer-name $load_balancer --max-size 5 --min-size 1 --desired-capacity 1
echo "Auto-scaling group is created."
echo "Done"
