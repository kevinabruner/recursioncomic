#sets the user permissions
source /etc/environment

sudo usermod -aG www-data $linuxUser

#drush alias
grep -qxF 'alias drush="/var/www/vendor/drush/drush/drush"' ~/.bashrc || echo 'alias drush="/var/www/vendor/drush/drush/drush"' >> /home/$linuxUser/.bashrc

#installs dependencies
DEBIAN_FRONTEND=noninteractive sudo apt-get update -yq
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -yq
DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq apache2 mysql-client php php-gd php-pdo php-mysql php-dom ncdu gh composer vim nfs-common htop


#enables and starts services
sudo systemctl enable apache2.service

##lets get some scripts to troubleshoot
scriptsDir="/home/$linuxUser/recursion-git-copy/"
rm -R $scriptsDir
mkdir $scriptsDir
cp ./ -R $scriptsDir