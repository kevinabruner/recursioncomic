#!/bin/bash

#vars passed in from github

dbName=$1
username=$2
password=$3
gitDir=$4
application=$5

bash $gitDir/scripts/install_deps.sh
bash $gitDir/scripts/mount_nfs.sh $linuxUser
bash $gitDir/scripts/composer_install.sh
bash $gitDir/scripts/populate_db.sh $dbName $username $password $linuxUser
bash $gitDir/scripts/configure_apache.sh $linuxUser $gitDir
bash $gitDir/scripts/configure_drupal.sh $dbName $username $password $gitDir $linuxUser