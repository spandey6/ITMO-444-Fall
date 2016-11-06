#!/bin/bash

aws rds create-db-instance --db-instance-identifier ITMO444-mysqldb-sudu --allocated-storage 10 --db-instance-class db.t2.micro --engine mysql --master-username user --master-user-password userpass
 
