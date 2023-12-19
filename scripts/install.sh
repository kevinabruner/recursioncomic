#!/bin/bash

#vars passed in from github

dbName=$1
username=$2
password=$3
gitDir=$4
application=$5
branch=$6

linuxUser=$SUDO_USER    


bash $gitDir/scripts/set_env_vars.sh $dbName $username $password $gitDir $application $branch
bash $gitDir/scripts/install_deps.sh 
bash $gitDir/scripts/mount_nfs.sh 
bash $gitDir/scripts/composer_install.sh 
bash $gitDir/scripts/populate_db.sh "$dbName" "$username" "$password" 
bash $gitDir/scripts/configure_apache.sh
bash $gitDir/scripts/configure_drupal.sh "$dbName" "$username" "$password"