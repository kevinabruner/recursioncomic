#!/bin/bash

application="recursioncomic"
linuxUser="$linuxUser"
gitDir=~/$application

dbName="drupal"
username='drupal'
password='obo74Cle'

#drush alias
grep -qxF 'alias drush="/var/www/vendor/drush/drush/drush"' ~/.bashrc || echo 'alias drush="/var/www/vendor/drush/drush/drush"' >> ~/.bashrc


#installs dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common


###nfs mounting###
nfsEntries=(
    /home/$linuxUser/db-dumps
    /var/www/web/sites/default/files
)

# Loop through each entry in nfsEntries
for entry in "${nfsEntries[@]}"; do
    sudo mkdir -p $entry
    sudo chown $linuxUser:www-data $entry
    nfsEntry="192.168.11.20:/mnt/yes/proxmox/gitbuilds/$application/$(basename $entry)    $entry  nfs    defaults    0 0"
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
sudo chown -R $linuxUser:www-data /var/www
cp composer.json composer.lock /var/www/
sudo rm -R /var/www/web /var/www/html
cd /var/www/

###installing composer###
yes | composer install
cd $gitDir


###database import###
sqlFile="/home/$linuxUser/db-dumps/drupal.sql" 

sudo systemctl enable mysql.service
sudo systemctl start mysql.service

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


###apache config###

sudo systemctl enable mysql.service
sudo systemctl start mysql.service

sudo sed -i 's#\s*DocumentRoot /var/www/html#DocumentRoot /var/www/web/#' /etc/apache2/sites-enabled/000-default.conf

sudo sed -i 's#<Directory "/var/www/html">.*AllowOverride None.*</Directory>#<Directory "/var/www/html">\n AllowOverride All\n</Directory>#' /etc/apache2/apache2.conf

sudo a2enmod rewrite

sudo systemctl apache2 restart

cd /var/www

drush='/var/www/vendor/drush/drush/drush'

$drush cr
yes | $drush updb