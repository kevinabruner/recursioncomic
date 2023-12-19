#!/bin/bash

#vars passed in from github

dbName=$1
username=$2
password=$3
gitDir=$4
application=$5
branch=$6

linuxUser=$SUDO_USER

bash $gitDir/scripts/install_deps.sh "$linuxUser"
bash $gitDir/scripts/mount_nfs.sh "$linuxUser" "$application"
bash $gitDir/scripts/composer_install.sh "$linuxUser" "$gitDir"
bash $gitDir/scripts/populate_db.sh "$dbName" "$username" "$password" "$linuxUser" "$branch"
bash $gitDir/scripts/configure_apache.sh
bash $gitDir/scripts/configure_drupal.sh "$dbName" "$username" "$password" "$gitDir" "$linuxUser"