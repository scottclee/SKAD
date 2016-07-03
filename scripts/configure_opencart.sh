# Not complete, but here's some of it
# The PHP set up already exists as scripts, however check the value of cgi.fix_pathinfo as it's 0 in here and 1 in configure_php.sh 

# This is the Web page where the below steps came from:
# https://www.howtoforge.com/tutorial/install-opencart-with-nginx-and-ssl-on-ubuntu-15-10/

raspi-config --expand-rootfs
apt-get update
apt-get upgrade
apt-get install nginx
apt-get install php5 php5-fpm php5-mysql php5-curl php5-gd php5-mcrypt
cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.orig
vi /etc/php5/fpm/php.ini


Uncomment line 773 and change the value to '0' :
cgi.fix_pathinfo=0

cd /etc/php5/fpm/conf.d/
ln -s ../../mods-available/mcrypt.ini mcrypt.ini


cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
vi /etc/nginx/sites-available/default


Uncomment the php-fpm directive:
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
        #
        #       # With php5-cgi alone:
        #       fastcgi_pass 127.0.0.1:9000;
        #       # With php5-fpm:
                fastcgi_pass unix:/var/run/php5-fpm.sock;
        }

cd /var/www/html/
echo "<?php phpinfo(); ?>" > info.php

systemctl restart nginx
systemctl restart php5-fpm

sudo apt-get install mariadb-server mariadb-client



mysql_secure_installation

Set root password? [Y/n] Y
Remove anonymous users? [Y/n] Y
Disallow root login remotely? [Y/n] Y
Remove test database and access to it? [Y/n] Y
Reload privilege tables now? [Y/n] Y


mysql -u root -p
TYPE YOUR PASSWORD

create database opencartdb;
create user opencartuser@localhost identified by 'opencartuser@';
grant all privileges on opencartdb.* to opencartuser@localhost identified by 'opencartuser@';
flush privileges;


ln -s /etc/nginx/sites-available/opencart /etc/nginx/sites-enabled/
nginx -t



wget http://www.opencart.com/index.php?route=download/download/success&download_id=44

mv index.html\?route\=download%2Fdownload opencart.zip







