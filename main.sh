#!/bin/bash
if (( $EUID == 0 )); then
    echo "Don't run this script as root."
    exit
fi
echo "WSL install script"


# INSTALL VARS
NGINX=0
PHP=0
GIT=0
COMP=0
MYSQL=0
# END INSTALL VARS

touch ~/upstart.sh
sudo apt-get update
sudo apt-get upgrade -y

# START Nginx
read -p "Install Nginx?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
NGINX=1
fi
# END Nginx

# START PHP7.1
read -p "Install PHP7.1?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
PHP=1
fi
# END PHP7.1

# START Git
read -p "Install Git?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
GIT=1
fi
# END Git

# START Composer
read -p "Install Composer?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
COMP=1
fi
# END Composer

# START Mysql Server 5.7
read -p "Install Mysql Server 5.7?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
MYSQL=1
fi
# END Mysql Server 5.7

echo "> Installing selected software..."

if (( $NGINX == 1 )); then
    ./nginx.sh
fi

if (( $PHP == 1 )); then
    ./php.sh
fi

if (( $GIT == 1 )); then
    ./git.sh
fi

if (( $COMP == 1 )); then
    ./comp.sh
fi

if (( $MYSQL == 1 )); then
    ./mysql.sh
fi
