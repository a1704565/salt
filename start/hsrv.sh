#!/bin/bash
#Copyright 2018 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0
#Based on work by Tero Karvinen:
#https://github.com/terokarvinen/sirotin/blob/master/run.sh
#http://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux
#
#
#This is a special version of start.sh without salt-minion

echo "Running the start script! Please wait..."

setxkbmap fi
sudo timedatectl set-timezone Europe/Helsinki
sleep 2s
sudo apt-get update
sudo apt-get install -y salt-master git
sudo git clone https://github.com/a1704565/salt.git /srv/salt

git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
git config --global user.name "Juha-Pekka Pulkkinen"
git config --global credential.helper "cache --timeout=3600"

echo "Everything complete! Salt-master and git have been isntalled, clone from github is ready."
