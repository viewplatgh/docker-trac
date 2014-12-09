#!/bin/bash
set -e 
service mysql restart
sudo mysql -u root -e "CREATE DATABASE trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
sudo mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by 'docker-trac1A~';"

service apache2 restart 

echo 'Start managing Trac with "tracadmin"...'
