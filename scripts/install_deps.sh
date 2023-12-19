#sets the user permissions
source /etc/environment

usermod -aG www-data $linuxUser

#drush alias
grep -qxF 'alias drush="/var/www/vendor/drush/drush/drush"' ~/.bashrc || echo 'alias drush="/var/www/vendor/drush/drush/drush"' >> /home/$linuxUser/.bashrc

#installs dependencies
DEBIAN_FRONTEND=noninteractive apt-get update -yq
DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 mysql-server php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common htop


#enables and starts services
systemctl enable mysql.service
systemctl start mysql.service

systemctl enable apache2.service
systemctl start apache2.service