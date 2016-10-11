#!/bin/bash

aws autoscaling update-auto-scaling-group --auto-scaling-group-name ITMO444-hw4 --min-size 0 --max-size 0 --desired-capacity 0

# De-register the instances form the load balancer
ID=aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone,State.Name,InstanceId]' | grep us-west-2b |grep running| grep pending| awk '{print $3}'
#aws elb deregister-instances-from-load-balancer --load-balancer-name ITMO-444-sudu --instances $ID
echo "De-registring the load balancer please wait....."
sleep 10
echo "Load balancer is de-registered."

# Detach autoscaling load balancer
aws autoscaling detach-load-balancers --load-balancer-names ITMO-444-sudu --auto-scaling-group-name ITMO444-hw4
echo "Detaching load blalancer please wait......."
sleep 70
echo "Load balancer is detached"

# Deleting autoscaling group
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name ITMO444-hw4
echo "Deleting auto scaling group please wait........."
sleep 10
echo "Auto scaling group deleted."

# Deleting launch configuration 
aws autoscaling delete-launch-configuration --launch-configuration-name ITMO-444-hw4
echo "Deleting launch configuration please wait........"
sleep 10
echo "Launch configuration deleted."

#Deleting load balancer
aws elb delete-load-balancer --load-balancer-name ITMO-444-sudu
echo "Load balancer deleted"
echo "Done"
