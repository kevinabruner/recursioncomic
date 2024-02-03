#!/bin/bash
source /etc/environment

###installing composer###
rm -R /var/www/web /var/www/html
cp $gitDir/composer.* /var/www/
cd /var/www/
sudo -u $linuxUser -g www-data composer install