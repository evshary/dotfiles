#!/bin/bash

# Refer to https://medium.com/@mattdark/backup-restore-github-gpg-ssh-keys-a335db22b953sudo%20apt%20install%20brave-browserk
#mv backup/id_rsa* ~/.ssh/
#chmod 600 ~/.ssh/id_ed25519
#chmod 644 ~/.ssh/id_ed25519.pub
#ssh-add ~/.ssh/id_ed25519
gpg --import backup/my-private-key.asc

