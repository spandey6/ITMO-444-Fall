#!/bin/bash

sudo apt-get update -y
sudo git clone git@github.com:illonois-itm/spandey6.git
sudo apt-get install -y php5-xm php5 apache2 php5-mysql curl php5-curl wget zip unzip git
sudo apt-get install -y libaoache2-mod-php

curl -sS https://getcomposer.org/installer | php

php composer.phar require aws/aws-sdk-php

sudo cd /var/www/html
sudo mv home/ubuntu/vendor /var/www/html

