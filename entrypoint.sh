#!/bin/bash
set -e 
service apache2 stop 
service mysql restart
mysql -u root -e "CREATE DATABASE trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by 'docker-trac1A~';"

echo 'Start managing Trac with "tracadmin"...'

main () {
	/usr/sbin/apache2 -DFOREGROUND
}

main
