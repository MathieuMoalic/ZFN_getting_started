#!/bin/sh
set -e

key_file="key"
read -p "pcss username: " user
mkdir -p ~/.ssh
# ssh-keygen -t ed25519 -f $key_path
echo Creating SSH config file
printf "Host pcss
  HostName eagle.man.poznan.pl
  User $user
  IdentityFile $key_file" > config
# ssh-copy-id pcss
printf "\nYou can now type 'ssh pcss' to connect to pcss\n"

echo "Setting up python (miniconda) on pcss"
ssh pcss 'bash -s' < pcss_setup.sh
