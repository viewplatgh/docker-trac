#!/bin/bash
set -e

MYSQLPASS=docker-trac1A~
FIRSTINIT=false 
if [ ! -f /root/.firstinit ]; then
    FIRSTINIT=true
fi

touch /root/.firstinit

if [ -f /root/.ssh/deploy_key ] && $FIRSTINIT; then
    cat << ENDHERE >> /root/.ssh/config
Host *
    IdentityFile /root/.ssh/deploy_key
    StrictHostKeyChecking no
ENDHERE
fi

service mysql restart

# Initialize MySQL
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
if $FIRSTINIT; then
    sudo mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by '$MYSQLPASS';"
fi

# Initialize Trac environment
if $FIRSTINIT; then
    trac-admin /usr/local/trac/docker-trac-demo initenv <<-END
    docker-trac-demo
    mysql://trac:$MYSQLPASS@localhost/trac	
END
    mv -f /usr/local/trac/trac.ini /usr/local/trac/docker-trac-demo/conf/
    trac-admin /usr/local/trac/docker-trac-demo permission add admin TRAC_ADMIN
    chown -R www-data:www-data /usr/local/trac
    chmod -R 775 /usr/local/trac
fi

# Add git repo need management
if $FIRSTINIT; then
    mkdir /usr/local/git
    #git clone git@... /usr/local/git/...
    chown -R www-data:www-data /usr/local/git
fi

service apache2 restart 
