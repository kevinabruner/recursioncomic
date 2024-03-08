#!/bin/bash
source /etc/environment

#adjusts the local settings
settingsDir="/var/www/web/sites/default"
cd $settingsDir
cp $gitDir/settings.php $settingsDir/

if [[ ${server} == 'prod1' || ${server} == 'prod2' ]]; then
    $dbHost="192.168.11.40"
else
    $dbHost="192.168.11.50"
fi

# Replace values in settings.php
sed -i.bak -E "s/\@@@dbName/$dbName/g" settings.php
sed -i.bak -E "s/\@@@username/$username/g" settings.php
sed -i.bak -E "s/\@@@password/$password/g" settings.php
sed -i.bak -E "s/\@@@dbHost/$dbHost/g" settings.php

# Remove backup files created by sed
rm settings.php.bak

#copies themes
cp -R $gitDir/themes/* /var/www/web/themes/contrib/

#chowns the correct ownership
chown -R $linuxUser:www-data /var/www

#updates using drush
cd /var/www
drush='/var/www/vendor/drush/drush/drush'
$drush cr
sudo -u $linuxUser -g www-data $drush updb