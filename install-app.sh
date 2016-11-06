#!/bin/bash

sudo apt-get install -y php-xm php php-mysql curl php-curl zip unzip git

export COMPOSER_HOME=/root && /usr/bin/composer.phar self-update 1.0.0-alpha11
curl -sS https://getcomposer.org/installer | php
php composer.phar require aws/aws-sdk-php
