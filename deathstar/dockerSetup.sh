#!/bin/bash

##Deathstarbench scripts:

##ssh -p 22 toslali@amd133.utah.cloudlab.us -Y -L 16686:localhost:16686

sudo apt update
sudo apt --yes install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt --yes install docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose –version


## stop docker to update work dir
sudo systemctl stop docker.service
sudo systemctl stop docker.socket

## create extrafs
sudo mkdir /mydata
sudo /usr/local/etc/emulab/mkextrafs.pl /mydata
sudo chmod ugo+rwx /mydata

SEARCH_STRING="ExecStart=/usr/bin/dockerd -H fd://"
REPLACE_STRING="ExecStart=/usr/bin/dockerd -g /mydata -H fd://"
sudo sed -i "s#$SEARCH_STRING#$REPLACE_STRING#" /lib/systemd/system/docker.service

sudo rsync -aqxP /var/lib/docker/ /mydata
sudo systemctl daemon-reload
sudo systemctl start docker
ps aux | grep -i docker | grep -v grep
echo "Check above for directory on where docker works"

