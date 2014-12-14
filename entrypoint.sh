#!/bin/bash
set -e

MYSQLPASS=docker-trac1A~

if [ -f /root/.ssh/deploy_key ]; then
    cat << END >> /root/.ssh/config
Host *
    IdentityFile /root/.ssh/deploy_key
    StrictHostKeyChecking no
END
fi

service mysql restart

# Initialize MySQL
sudo mysql -u root -e "CREATE DATABASE trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
sudo mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by '$MYSQLPASS';"

# Initialize Trac environment
trac-admin /usr/local/trac/docker-trac-demo initenv <<-END
docker-trac-demo
mysql://trac:$MYSQLPASS@localhost/trac	
END
mv -f /usr/local/trac/trac.ini /usr/local/trac/docker-trac-demo/conf/
trac-admin /usr/local/trac/docker-trac-demo permission add admin TRAC_ADMIN

# Add git repo need management
RUN mkdir /usr/local/git
#git clone git@... /usr/local/git/...
chown -R www-data:www-data /usr/local/git

service apache2 restart 
