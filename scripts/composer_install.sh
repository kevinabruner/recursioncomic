#!/bin/bash
source /etc/environment

###installing composer###
cp $gitDir/composer.* /var/www/
cd /var/www/
sudo rm -R vendor 
sudo -u $linuxUser -g www-data composer install