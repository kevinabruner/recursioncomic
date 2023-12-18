#!/bin/bash

dbName="drupal"
username='drupal'
password='obo74Cle'

cd /home/kevin/db-dumps
mysqldump -u $username -p$password drupal > drupal.sql
rsync -avr /var/www/web/sites/default/files/* /home/kevin/files/