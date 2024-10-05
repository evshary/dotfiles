#!/bin/bash

# Refer to https://medium.com/@mattdark/backup-restore-github-gpg-ssh-keys-a335db22b953sudo%20apt%20install%20brave-browserk
mv backup/id_rsa* ~/.ssh/
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
ssh-add ~/.ssh/id_rsa
gpg --import backup/my-private-key.asc

