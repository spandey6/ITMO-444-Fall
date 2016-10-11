#!/bin/bash
#Create Load balancer
aws elb create-load-balancer --load-balancer-name ITMO-444-sudu --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnets subnet-a8dcaede --security-groups sg-0e14c377
echo "Load Balancer is Created"

# Creating autoscaling launch configuration
aws autoscaling create-launch-configuration --launch-configuration-name ITMO-444-hw4 --image-id ami-06b94666 --security-groups sg-0e14c377 --key-name spandey --instance-type t2.micro --user-data file://installenv.sh
echo "Launch configuration is created."

# Creating autoscaling group
aws autoscaling create-auto-scaling-group --auto-scaling-group-name ITMO444-hw4 --launch-configuration ITMO-444-hw4 --availability-zone us-west-2b --load-balancer-name ITMO-444-sudu --max-size 5 --min-size 2 --desired-capacity 3
echo "Auto-scaling group is created."

# Attaching the load balancer to the group
aws autoscaling attach-load-balancers --load-balancer-names ITMO-444-sudu --auto-scaling-group-name ITMO444-hw4
echo "Done"
