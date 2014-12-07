# Reference: http://trac.edgewall.org/wiki/Ubuntu-10.04.03-Git 
FROM stackbrew/ubuntu:trusty

RUN apt-get update

RUN apt-get install -y apache2 apache2-utils libapache2-mod-python python-setuptools python-genshi 

RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password docker-trac1A~'

RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password docker-trac1A~'
 
RUN apt-get install -y mysql-server

ADD my.cnf /root/.my.cnf

RUN apt-get install -y python-mysqldb

RUN apt-get install -y git-core

RUN apt-get install trac trac-git

# Create git repositories
RUN mkdir /usr/local/git
#RUN git clone https://... /usr/local/git/...
#RUN chown -R www-data:www-data /usr/loca/git/...

# Setup MySQL
RUN mysql -u root -e "CREATE DATABASE trac DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
RUN mysql -u root -e "GRANT ALL ON trac.* TO trac@localhost IDENTIFIED by 'docker-trac1A~';"


# Trac
RUN mkdir /usr/local/trac
RUN mkdir /usr/local/trac/docker-trac-demo

# Configure Trac
# ...

RUN chown -R www-data:www-data /usr/local/trac/docker-trac-demo

# Configure Apache
# ...
RUN cd /usr/local/trac && htpasswd -bc .htpasswd admin docker-trac1A~

RUN /etc/init.d/apache2 restart

RUN trac-admin /var/lib/trac/docker-trac-demo permission add admin TRAC-ADMIN


# Install entrypoint
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
