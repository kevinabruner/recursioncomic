#!/bin/bash

dbName=$1
username=$2
password=$3
gitDir=$4
linuxUser=$5

#adjusts the local settings
settingsDir="/var/www/web/sites/default"
cd $settingsDir
cp $gitDir/settings.php $settingsDir/
# Replace values in settings.php
sed -i.bak -E "s/^\s*'database'\s*=>\s*'[^']*'/  'database' => '$dbName'/" settings.php
sed -i.bak -E "s/^\s*'username'\s*=>\s*'[^']*'/  'username' => '$username'/" settings.php
sed -i.bak -E "s/^\s*'password'\s*=>\s*'[^']*'/  'password' => '$password'/" settings.php

# Remove backup files created by sed
rm settings.php.bak

#copies themes
cp -R $gitDir/themes/* /var/www/web/themes/contrib/

#copies user-uploaded files stored in a network share
filesDir="/var/www/web/sites/default/files/"
rsync -avr /home/$linuxUser/files/* $filesDir/

#chowns the correct ownership
chown -R $linuxUser:www-data /var/www

#updates using drush
cd /var/www
drush='/var/www/vendor/drush/drush/drush'
$drush cr
yes | sudo -u $linuxUser -g www-data $drush updb