#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install git
sudo apt-get -y install apache2

sudo systemctl enable apache2
sudo systemctl start apache2

cd /home/ubuntu/spandey6

sudo git clone git@github.com:illonois-itm/spandey6.git
sudo apt-get install -y php5-xm php5 apache2 php5-mysql curl php5-curl wget zip unzip git php5-cli
sudo apt-get install -y libapache2-mod-php

curl -sS https://getcomposer.org/installer | php

php composer.phar require aws/aws-sdk-php

sudo cd /var/www/html
sudo mv home/ubuntu/vendor /var/www/html

sudo service apache2 restart

