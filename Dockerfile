# Reference: 
# http://trac.edgewall.org/wiki/Ubuntu-10.04.03-Git
# http://github.com/phusion/baseimage-docker 		 
#FROM stackbrew/ubuntu:trusty
FROM phusion/baseimage:0.9.15

MAINTAINER Rob Lao "viewpl@gmail.com"

ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Add public key for ssh service
ADD key.pub /key.pub
RUN cat /key.pub >> /root/.ssh/authorized_keys && rm -f /key.pub


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_USER_UID 0

RUN apt-get update

# Install Apache2...
RUN apt-get install -y apache2 apache2-utils libapache2-mod-python python-setuptools python-genshi

RUN a2enmod rewrite

# Install MySQL...
#RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password docker-trac1A~'
RUN echo 'mysql-server mysql-server/root_password password docker-trac1A~' | debconf-set-selections 
#RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password docker-trac1A~'
RUN echo 'mysql-server mysql-server/root_password_again password docker-trac1A~' | debconf-set-selections 
RUN apt-get install -y mysql-server
ADD my.cnf /root/.my.cnf
RUN apt-get install -y python-mysqldb

RUN apt-get install -y git-core

RUN apt-get install -y trac trac-git

# Create git repositories
RUN mkdir /usr/local/git
#RUN git clone https://... /usr/local/git/...
#RUN chown -R www-data:www-data /usr/loca/git/...

# Trac
RUN mkdir /usr/local/trac
RUN mkdir /usr/local/trac/docker-trac-demo

# Configure Trac
# ...

RUN chown -R www-data:www-data /usr/local/trac/docker-trac-demo

# Configure Apache
# ...
# 

RUN cd /usr/local/trac && htpasswd -bc .htpasswd admin docker-trac1A~


# Assign permission to admin
#RUN trac-admin /var/lib/trac/docker-trac-demo permission add admin TRAC-ADMIN

# Install entrypoint
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
#RUN mkdir -p /etc/my_init.d
#ADD entrypoint.sh /etc/my_init.d/entrypoint.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
