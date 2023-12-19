#!/bin/bash

dbName=$1
username=$2
password=$3
linuxUser=$4
branch=$5

###database import###
sqlFile="/home/$linuxUser/db-dumps/drupal.sql" 

# Create the database
mysql -e "CREATE DATABASE IF NOT EXISTS $dbName;"

echo "The branch is: $branch"

#mysql user
mysql -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
mysql -e "GRANT ALL PRIVILEGES ON $dbName.* TO '$username'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Import data into the database from SQL file
mysql -u"$username" -p"$password" "$dbName" < "$sqlFile"