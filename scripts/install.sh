#!/bin/bash

#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer

sudo chown -R kevin:www-data /var/www
cd /var/www/

cp composer.json composer.lock /var/www/
composer install
cd -
cp -R themes/* /var/www/html/themes/

#database import

#file connection