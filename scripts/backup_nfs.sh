#!/bin/bash

source /etc/environment

backupDir="/home/$linuxUser/nfs-backups"

###nfs mounting###
cephEntries=(    
    /var/www/web/sites/default/files/
)

for entry in "${nfsEntries[@]}"; do
    sudo mkdir -p $backupDir/$HOSTNAME
    sudo cp -R $entry $backupDir/$HOSTNAME/$(basename $entry)    
    sudo chown -R $linuxUser:www-data $backupDir/$HOSTNAME/$(basename $entry)    
done    
