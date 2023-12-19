#!/bin/bash

###apache config###
sed -i 's#\s*DocumentRoot /var/www/html#DocumentRoot /var/www/web/#' /etc/apache2/sites-enabled/000-default.conf
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

a2enmod rewrite
systemctl restart apache2