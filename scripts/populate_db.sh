#!/bin/bash
source /etc/environment

dbName=$1
username=$2
password=$3

###database import###
sqlFile="/home/$linuxUser/db-dumps/drupal.sql" 

# Check if the database exists
databaseExists=$(mysql -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$dbName';" -s)

if [ -z "$databaseExists" ]; then
    # Create the database
    mysql -e "CREATE DATABASE IF NOT EXISTS $dbName;"

    #mysql user
    mysql -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
    mysql -e "GRANT ALL PRIVILEGES ON $dbName.* TO '$username'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    # Import data into the database from SQL file
    mysql -u"$username" -p"$password" "$dbName" < "$sqlFile"
else
  echo "Database already exists. Skipping creation and import."
fi