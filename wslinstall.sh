#!/bin/bash
if (( $EUID = 0 )); then
    echo "Don't run this script as root."
    exit
fi

echo "============="
echo "WSL install script"
echo "-- by IndianCurry"
echo "============="

echo "This script will install apache2, php7.1 (+mods), mysql-server-5.7, git and composer.";
echo "It will prompt to install the Laravel installer and Drush";

read -p "Do you wish to continue?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
export DEBIAN_FRONTEND=noninteractive

echo "============="
echo "Adding PHP/apache2 repositories."
echo "============="

sudo add-apt-repository ppa:ondrej/php -y
sudo add-apt-repository ppa:ondrej/apache2 -y
echo "============="
echo "Updating..."
echo "============="
sudo apt-get update
echo "============="
echo "Upgrading..."
echo "============="
sudo apt-get upgrade -y
echo "============="
echo "Installing apache2"
echo "============="
sudo apt-get install -y --force-yes apache2 libapache2-mod-auth-mysql
echo "============="
echo "Configuring apache2..."
echo "============="
echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo "AcceptFilter http none" >> /etc/apache2/apache2.conf

echo "============="
echo "Installing PHP7.1 + mods"
echo "============="
sudo apt-get install -y --force-yes php7.1 php7.1-mysql php7.1-zip php7.1-mbstring php7.1-dom php7.1-xml php7.1-mysql php7.1-gd php7.1-curl

echo "============="
echo "Installing Composer"
echo "============="
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo chown -R $USER $HOME/.composer/
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "============="
echo "Installing Git"
echo "============="
sudo apt-get install -y --force-yes git

read -p "Install the Laravel installer?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
composer global require "laravel/installer"
fi

read -p "Install Drush@8.1.12?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
composer global require "drush/drush:8.1.12"
fi


echo "============="
echo "Downloading MYSQL config"
echo "============="
wget https://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb

echo "============="
echo "Setting MYSQL apt-config values."
echo "> distro: ubuntu/trusty"
echo "> server: mysql-server-5.7"
echo "> username: root (default)"
echo "> password: secret"
echo "============="
sudo echo mysql-apt-config mysql-apt-config/repo-distro select ubuntu | debconf-set-selections
sudo echo mysql-apt-config mysql-apt-config/repo-codename select trusty | debconf-set-selections
sudo echo mysql-apt-config mysql-apt-config/select-server select mysql-5.7 | debconf-set-selections
sudo echo mysql-community-server mysql-community-server/root-pass password secret | debconf-set-selections
sudo echo mysql-community-server mysql-community-server/re-root-pass password secret | debconf-set-selections
sudo dpkg -i mysql-apt-config_0.6.0-1_all.deb

sudo apt-key adv --keyserver pgp.mit.edu --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

echo "============="
echo "Updating..."
echo "============="
sudo apt-get update
echo "============="
echo "Installing mysql-server-5.7"
echo "============="
sudo apt-get install -y --force-yes mysql-server

echo "============="
echo "Cleaning up..."
echo "============="
rm mysql-apt-config_0.6.0-1_all.deb
sudo rm /etc/apache2/sites-available/000-default.conf
sudo rm /etc/apache2/sites-enabled/000-default.conf

echo "============="
echo "Restarting services"
echo "> mysql"
sudo service mysql restart
echo "> php7.1-fpm"
sudo service php7.1-fpm restart
echo "> apache2"
sudo service apache2 restart
echo "============="

echo "============="
echo "All done. Enjoy!"
echo "> Connect to MYSQL using:"
echo ">> Host Name: localhost"
echo ">> Port: 3306"
echo ">> Username: root"
echo ">> Password: secret"
echo "-- WSL install script by: IndianCurry"
echo "============="
fi
