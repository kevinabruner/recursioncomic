#!/bin/bash
dbName=$1
username=$2
password=$3
gitDir=$4
application=$5
branch=$6
linuxUser=$SUDO_USER

# Check if /etc/environment file exists and create it if not
if [ ! -f /etc/environment ]; then
  sudo touch /etc/environment
fi

# Function to update or append variable to /etc/environment
update_env() {
  if grep -q "^$1=" /etc/environment; then
    sudo sed -i "s|^$1=.*|$1=\"$2\"|g" /etc/environment
  else
    echo "$1=\"$2\"" | sudo tee -a /etc/environment > /dev/null
  fi
}

# Update or append variables with their values
update_env "linuxUser" "$linuxUser"
update_env "gitDir" "$gitDir"
update_env "application" "$application"
update_env "branch" "$branch"
update_env "dbName" "$dbName"
update_env "username" "$username"
update_env "password" "$password"