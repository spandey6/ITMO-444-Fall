#!/bin/bash

# Terminating instances
aws autoscaling terminate-instance-in-auto-scaling-group --auto-scaling-group-name ITMO444 --termination-policies "Default, NewestInstance" 

#Register instances from load balancer
#aws autoscaling update-auto-scaling-group --auto-scaling-group-name ITMO444 --min-size 0 --max-size 5 --desired-capacity 1

# De-register the instances form the load balancer
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone,State.Name,InstanceId]' | grep us-west-2b |grep running| grep pending| awk '{print $3}'
#aws elb deregister-instances-from-load-balancer --load-balancer-name ITMO-444-sudu --instances $ID
echo "De-registring the load balancer please wait....."
wait
echo "Load balancer is de-registered."

# Detach autoscaling load balancer
aws autoscaling detach-load-balancers --load-balancer-names ITMO-444-sudu --auto-scaling-group-name ITMO444
echo "Detaching load blalancer please wait......."
wait
echo "Load balancer is detached"

# Deleting autoscaling group
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name ITMO444
echo "Deleting auto scaling group please wait........."
wait
echo "Auto scaling group deleted."

# Deleting launch configuration 
aws autoscaling delete-launch-configuration --launch-configuration-name $4
echo "Deleting launch configuration please wait........"
wait
echo "Launch configuration deleted."

#Deleting load balancer
aws elb delete-load-balancer --load-balancer-name ITMO-444-sudu
echo "Load balancer deleted"

#delete db instances
aws rds delete-db-instance --skip-final-snapshot --db-instance-identifier $db-id-for-instance
aws rds wait db-instance-deleted --db-instance-identifier $db-id-for-instance
echo "Database deleted"
echo "Done"
