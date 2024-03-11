#!/bin/bash

OPTSTRING=":p:w:a:b:s:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    p)
      password=$OPTARG
      ;;    
    w)
      gitDir=$OPTARG
      ;;
    a)
      application=$OPTARG
      ;;
    b)
      branch=$OPTARG
      ;;
    s)
      server=$OPTARG
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

linuxUser=$SUDO_USER

if [[ ${server} == 'prod1' || ${server} == 'prod2' ]]; then
    dbHost="192.168.80.60"
else
    dbHost="192.168.80.50"
fi

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

username=$application
dbName=$application

# Update or append variables with their values
update_env "linuxUser" "$linuxUser"
update_env "gitDir" "$gitDir"
update_env "application" "$application"
update_env "branch" "$branch"
update_env "dbName" "$dbName"
update_env "username" "$username"
update_env "password" "$password"
update_env "dbHost" "$dbHost"
update_env "server" "$server"

###scriplets to install application***
bash $gitDir/scripts/pre_install.sh 
bash $gitDir/scripts/install_deps.sh 
bash $gitDir/scripts/mount_nfs.sh 
bash $gitDir/scripts/composer_install.sh 
bash $gitDir/scripts/populate_db.sh 
bash $gitDir/scripts/configure_apache.sh
bash $gitDir/scripts/configure_drupal.sh 
bash $gitDir/scripts/post_install.sh 