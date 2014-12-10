#!/bin/bash
set -e

service mysql restart

sudo mysql -u root -e "CREATE DATABASE trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
sudo mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by 'docker-trac1A~';"

trac-admin /usr/local/trac/docker-trac-demo initenv <<-END
docker-trac-demo
mysql://trac:docker-trac1A~@localhost/trac	
END
mv -f /usr/local/trac/trac.ini /usr/local/trac/docker-trac-demo/conf/
trac-admin /usr/local/trac/docker-trac-demo permission add admin TRAC_ADMIN

service apache2 restart 

echo 'Start managing Trac with "tracadmin"...'
