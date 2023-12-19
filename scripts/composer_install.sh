#!/bin/bash
source /etc/environment

###installing composer###
cp $gitDir/composer.json $gitDir/composer.lock /var/www/
rm -R /var/www/web /var/www/html
cd /var/www/
yes | sudo -u $linuxUser -g www-data composer install