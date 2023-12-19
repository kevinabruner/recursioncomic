#!/bin/bash

dbName=$1
username=$2
password=$3

cd /home/kevin/db-dumps
mysqldump -u $username -p$password drupal > drupal.sql
rsync -avr /var/www/web/sites/default/files/* /home/kevin/files/