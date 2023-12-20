#!/bin/bash
source /etc/environment

cd /home/$linuxUser/db-dumps

#dumps the live DB
mysqldump -u $username -p$password $dbName --no-tablespaces > /home/$linuxUser/db-dumps/$dbName.sql

#dumps the live user files
rsync -avr /var/www/web/sites/default/files/* /home/$linuxUser/files/