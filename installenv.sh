#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install git
sudo apt-get -y install apache2

sudo systemctl enable apache2
sudo systemctl start apache2

sudo apt-get install -y php-xm php php-mysql curl php-curl zip unzip git


cd /home/ubuntu/spandey6
git clone git@github.com:illonois-itm/spandey6.git
