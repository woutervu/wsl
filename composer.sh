#!/bin/bash
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo chown -R $USER $HOME/.composer/
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

read -p "Install the Laravel installer?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
composer global require "laravel/installer"
fi

read -p "Install Drush@8.x?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
composer global require "drush/drush:8.x"
fi

source ~/.bashrc
