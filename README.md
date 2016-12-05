# ITMO-444
install-app.sh file is used for updating the system, installing all the dependencies that is needed for the project like apache2 server, php5, curl, and many more.
create-env-sh is used for running the instances and it is coded on positional parameters so you have to add AMI ID, key name, security-group, launch configuration, load balancer name, autoscaling group name, and the number of instances you want to run.
create-app-env.sh file creates the rds database and the name of the database is hard coded "fb-spd-db" username is "controller" password is "letmein55".
This file also creates the sns topic, subscibe the topic which used the hardcoded arn to my personal email notification, it also creates the sqs queue namedITMO444, created the s3 buckets named raw-spd and finished-spd, and uploaded the pictures in both s3 buckets.
destroy-env.sh contains all the destroy commands for the aws that we did like filters for the instance id, load balancrs, autoscaling group, launch configuration, and database instance id. Force deletes all the buckets with files in it. Deletes sns topic, database, autoscaling, launch configuration, load balancer, and terminates the instances.
index.php creates php page that will show simple page for the user where they can have to input their email and subimt then the page is directed to the welcome.php page.
welcome.php page shows the email that is loged in where user is able to choose the file that they want to upload. Uploading file will be headed to galarry.php file through upload.php file.
upload.php will help upload the picture and then post the action to uploader.php
uploader.php starts the session then it creates the s3 datablase. Session for the email is started and file is sent to the tmpfile of the user. Prepared statement is added, which will pass by reference and select statement from the table is added.
galary.php will post the email of the user, connect to the rds database then l
ink with the controller user and then link with the table. It will also show a
ll the pictures from the s3 finished and raw buckets.
dbtest creates the rds database then it also creates the table needed for the
project. 
