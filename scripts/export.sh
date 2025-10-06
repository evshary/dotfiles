#!/bin/bash

# Refer to https://medium.com/@mattdark/backup-restore-github-gpg-ssh-keys-a335db22b953sudo%20apt%20install%20brave-browserk
mkdir backup
#cp ~/.ssh/id_* backup
gpg_id=`gpg --list-secret-keys --keyid-format LONG | grep sec | awk -F/ '{print $2}' | awk '{print $1}'`
gpg --export-secret-keys $gpg_id > backup/my-private-key.asc

