#!/bin/bash

#vars passed in from github

dbName=$1
username=$2
password=$3
gitDir=$4
application=$5

./install_deps.sh
./mount_nfs.sh $linuxUser
./composer_install.sh
./populate_db.sh $dbName $username $password $linuxUser
./configure_apache.sh $linuxUser $gitDir
./configure_drupal.sh $dbName $username $password $gitDir $linuxUser