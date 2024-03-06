#!/bin/bash
source /etc/environment

###nfs mounting###
nfsEntries=(
    /home/$linuxUser/db-dumps
    /var/www/web/sites/default/files/
)


# Loop through each entry in nfsEntries
for entry in "${nfsEntries[@]}"; do
    mkdir -p $entry
    chown $linuxUser:www-data $entry
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
