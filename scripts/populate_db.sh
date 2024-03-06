#!/bin/bash
source /etc/environment

###database import###
sqlFile="/home/$linuxUser/db-dumps/*.sql" 

# Check if the SQL file exists
if [ -f "$sqlFile" ]; then        
    # Import data into the database from SQL file
    mysql -h "$dbHost" -u "$username" -p"$password" "$dbName" < "$sqlFile"
    
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