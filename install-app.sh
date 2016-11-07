#!/bin/bash

sudo apt-get update -y
sudo clone git clone git@github.com:illonois-itm/spandey6.git
sudo apt-get install -y php-xm php5 apache2 php-mysql curl php-curl php5-curl zip unzip git

curl -sS https://getcomposer.org/installer | php

php composer.phar require aws/aws-sdk-php

