#!/bin/bash
source /etc/environment

cd /home/$linuxUser/db-dumps

#dumps the live DB
mysqldump -h $dbHost -u $username -p$password $dbName --no-tablespaces > /home/$linuxUser/db-dumps/$dbName.sql