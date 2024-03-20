#!/bin/bash

source /etc/environment

backupDir="/home/$linuxUser/nfs-backups"

###nfs mounting###
cephEntries=(    
    /var/www/web/sites/default/files/
)

for entry in "${cephEntries[@]}"; do
    sudo mkdir -p $backupDir/backup-files
    sudo rsync -avr --ignore-existing --delete $entry $backupDir/backup-files/$(basename $entry)    
    sudo chown -R $linuxUser:www-data $backupDir/backup-files/$(basename $entry)    
done    
