#!/bin/bash
source /etc/environment

###database import###
sqlFile="/home/$linuxUser/db-dumps/$dbName.sql" 

# Check if the SQL file exists
if [ -f "$sqlFile" ]; then
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
else
    echo "SQL file $sqlFile does not exist. Database import cannot proceed."
fi



###crontab manipulation for DB backups****
scriptPath=$gitDir/scripts/db_dump.sh

# Check if the current branch is main
if [ "$branch" = "refs/heads/main" ]; then
  # Check if the cron job already exists
  if ! crontab -l | grep -q "$scriptPath"; then
    # Add the cron job to run the script every night at 2 AM
    (crontab -l ; echo "0 2 * * * $scriptPath") | crontab -
    echo "Cron job added to run $scriptPath every night at 2 AM."
  else
    echo "Cron job already exists for $scriptPath."
  fi
else
  echo "The branch is not main. Skipping cron job addition."
fi