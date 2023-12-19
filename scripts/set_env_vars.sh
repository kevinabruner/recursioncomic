#!/bin/bash
linuxUser=$1
gitDir=$2
application=$3
branch=$4

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