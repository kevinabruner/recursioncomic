#!/bin/bash

gitDir=$PWD

dbName="drupal"
username='drupal'
password='obo74Cle'

#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common


###nfs mounting###
nfsEntries=(
    /home/kevin/db-dumps
    /var/www/html/sites/default/files
)

# Loop through each entry in nfsEntries
for entry in "${nfsEntries[@]}"; do
    sudo mkdir -p $entry
    sudo chown kevin:www-data $entry
    nfsEntry="192.168.11.20:/mnt/yes/proxmox/gitbuilds/recursioncomic/$(basename $entry)    $entry  nfs    defaults    0 0"
    # Check if the entry exists in /etc/fstab
    if ! grep -qF "$nfsEntry" /etc/fstab; then
        # If entry does not exist, append it to /etc/fstab
        echo "$nfsEntry" | sudo tee -a /etc/fstab >/dev/null
        echo "Added: $entry to /etc/fstab"
    else
        echo "Entry already exists: $entry"
    fi
done

sudo mount -a

###chowning the web folders###
sudo chown -R kevin:www-data /var/www
cp composer.json composer.lock /var/www/
sudo rm -R /var/www/html
cd /var/www/

###installing composer###
composer install
cd $gitDir
cp -R themes/* /var/www/html/themes/
ln -s /var/www/web /var/www/html



#database import

sqlFile="/home/kevin/db-dumps/drupal.sql" 

# Create the database
mysql -u"$username" -p"$password" -e "CREATE DATABASE IF NOT EXISTS $dbName;"

# Import data into the database from SQL file
mysql -u"$username" -p"$password" "$dbName" < "$sqlFile"

echo "Database '$dbName' created and data imported successfully."





#file connection
