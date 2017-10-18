#!/bin/bash
echo "> Downloading MySQL config..."
wget https://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb
echo "> Setting MySQL config..."

export DEBIAN_FRONTEND=noninteractive

echo mysql-apt-config mysql-apt-config/repo-distro select ubuntu | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/repo-codename select trusty | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-server select mysql-5.7 | sudo debconf-set-selections
echo mysql-community-server mysql-community-server/root-pass password secret | sudo debconf-set-selections
echo mysql-community-server mysql-community-server/re-root-pass password secret | sudo debconf-set-selections
sudo dpkg -i mysql-apt-config_0.6.0-1_all.deb

sudo apt-key adv --keyserver pgp.mit.edu --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

echo "> Updating..."
sudo apt-get update
echo "> Installing mysql-server-5.7"
sudo apt-get install -y --force-yes mysql-server

echo "> Cleaning up..."
rm mysql-apt-config_0.6.0-1_all.deb

echo "> Adding php7.1-fpm to ~/upstart.sh"
echo "service mysql stop " >> ~/upstart.sh
echo "service mysql start " >> ~/upstart.sh

echo "> Connect to MYSQL using:"
echo ">> Host Name: localhost"
echo ">> Port: 3306"
echo ">> Username: root"
echo ">> Password: secret"
