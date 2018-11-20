#!/bin/bash
#based on work by Tero Karvinen, Source: https://github.com/terokarvinen/sirotin/blob/master/run.sh
#also based on other work by Tero Karvinen; Source: http://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux

echo "Starting! Please wait..."

setxkbmap fi
sudo apt-get update
sudo apt-get install -y salt-master salt-minion git
sudo timedatectl set-timezone Europe/Helsinki
sudo git clone https://github.com/a1704565/salt.git /srv/salt

git config --global user.email "juha-pekka.pulkkinen@myy.haaga-helia.fi"
git config --global user.name "Juha-Pekka Pulkkinen"

git config --global credential.helper "cache --timeout=3600"

echo -e 'master: localhost\nid: labrabuntu'|sudo tee /etc/salt/minion

echo "Done."
