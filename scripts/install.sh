#!/bin/bash

gitDir=~/recursioncomic

dbName="drupal"
username='drupal'
password='obo74Cle'

#drush alias
grep -qxF 'alias drush="/var/www/vendor/drush/drush/drush"' ~/.bashrc || echo 'alias drush="/var/www/vendor/drush/drush/drush"' >> ~/.bashrc


#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common

sudo sed -i 's#\s*DocumentRoot /var/www/html#DocumentRoot /var/www/web/#' /etc/apache2/sites-enabled/000-default.conf


###nfs mounting###
nfsEntries=(
    /home/kevin/db-dumps
    /var/www/web/sites/default/files
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
sudo rm -R /var/www/web /var/www/html
cd /var/www/

###installing composer###
composer install
cd $gitDir


###database import###
sqlFile="/home/kevin/db-dumps/drupal.sql" 

# Create the database
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $dbName;"

#mysql user
sudo mysql -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $dbName.* TO '$username'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Import data into the database from SQL file
mysql -u"$username" -p"$password" "$dbName" < "$sqlFile"


#adjusts the local settings
settingsDir="/var/www/web/sites/default"
cp $gitDir/settings.php $settingsDir/

#copies themes
cp -R $gitDir/themes/* /var/www/web/themes/contrib/

sudo systemctl apache2 restart

cd /var/www

drush cr
drush updb