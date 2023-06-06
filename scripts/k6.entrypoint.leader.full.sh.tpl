#!/bin/bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg2 apt-transport-https
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list

sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential git libssl-dev libffi-dev python3 python3-dev python3-pip python3-setuptools python3-wheel python3-virtualenv openjdk-11-jdk-headless default-jdk-headless curl unzip apache2 k6

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install elasticsearch logstash filebeat

# APACHE
sudo systemctl enable apache2
sudo systemctl start apache2
sudo chmod -r 777 /var/www/html
sudo rm -rf /var/www/html/*

curl -XGET https://localhost:9200 -u 'admin:admin' --insecure
curl -XGET https://localhost:9200/_cat/nodes?v -u 'admin:admin' --insecure
curl -XGET https://localhost:9200/_cat/plugins?v -u 'admin:admin' --insecure

export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

touch /tmp/finished-setup
