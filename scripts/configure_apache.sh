#!/bin/bash
source /etc/environment

###apache config###
sudo sed -i 's#\s*DocumentRoot /var/www/html#DocumentRoot /var/www/web/#' /etc/apache2/sites-enabled/000-default.conf
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

sudo mkdir -p /var/www/config/sync
sudo chown $linuxUser:www-data /var/www/config/sync

sudo a2enmod rewrite
sudo systemctl restart apache2