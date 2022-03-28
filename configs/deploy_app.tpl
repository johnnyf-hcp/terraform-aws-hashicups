#!/bin/bash
# Script to deploy hashicups containers
# install docker
sudo su
yum update -y
yum install git -y
yum install docker -y
# start
systemctl enable docker.service
systemctl start docker.service
# get docker compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod -v +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# clone hashicups setup
git clone https://github.com/johnnyf-hcp/hashicups-setups.git
cd hashicups-setups/docker-compose-deployment
# replace the public-api URL with the public URL
sed -i "s/public-api:8080/$(curl http://checkip.amazonaws.com):8080/" docker-compose.yaml
# deploy the containers
docker-compose up -d