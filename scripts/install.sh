#!/bin/bash

#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common

sudo chown -R kevin:www-data /var/www
cp composer.json composer.lock /var/www/
sudo rm -R /var/www/html
cd /var/www/

composer install
cd ~/recursioncomic
cp -R themes/* /var/www/html/themes/

ln -s /var/www/web /var/www/html

#database import

#file connection
