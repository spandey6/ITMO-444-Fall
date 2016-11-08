#!/bin/bash

ID='aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[].InstanceId''
echo "Instance ID: " $ID
load_balancer_name='aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].LoadBalancerName''
echo "Load Balancer Name: "$load_balancer_name
autoscaling_group='aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalinGroupsName''
echo "Auto Scaling Group Name: " $autoscaling_group
launch_confiuration='aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName''
echo "Launch Confiuragration Name: " $launch_configuration

# De-register the instances form the load balancer
aws elb deregister-instances-from-load-balancer --load-balancer-name $load_balalncer_name --instances $ID
echo "De-registring the load balancer please wait.....
wait
echo "Load balancer is de-registered."

# Terminating instances
aws ec2 wait terminate-instances --instance-ids $ID
echo "Instances Terminating please wait......."

# Detach autoscaling load balancer
aws autoscaling detach-load-balancers --load-balancer-names $load_balancer_name --auto-scaling-group-name $autoscaling_group
echo "Detaching load blalancer please wait......."
echo "Load balancer is detached"

# Deleting autoscaling group
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $autoscaling_group
echo "Deleting auto scaling group please wait........."
echo "Auto scaling group deleted."

# Deleting launch configuration 
aws autoscaling delete-launch-configuration --launch-configuration-name $launch_configuration
echo "Deleting launch configuration please wait........"
wait
echo "Launch configuration deleted."

#Deleting load balancer
aws elb delete-load-balancer --load-balancer-name $load_balancer_name
echo "Load balancer deleted"

#delete db instances
aws rds delete-db-instance --skip-final-snapshot --db-instance-identifier $db-id-for-instance
aws rds wait db-instance-deleted --db-instance-identifier $db-id-for-instance
echo "Database deleted"
echo "Done"
