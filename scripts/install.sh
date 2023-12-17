#!/bin/bash

gitDir=$PWD

#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common


###nfs mounting###
nfsEntries=(
    "192.168.11.20:/mnt/yes/proxmox    /home/kevin/nfs_test    nfs    defaults    0 0"
)

# Loop through each entry in nfsEntries
for entry in "${nfsEntries[@]}"; do
    # Check if the entry exists in /etc/fstab
    if ! grep -qF "$entry" /etc/fstab; then
        # If entry does not exist, append it to /etc/fstab
        echo "$entry" | sudo tee -a /etc/fstab >/dev/null
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





#file connection
