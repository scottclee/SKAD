# Kudos to this tutorial:
# https://www.howtoforge.com/tutorial/installing-nginx-with-php-fpm-and-mariadb-lemp-on-debian-jessie/

apt-get -y install php5-fpm

# cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
# It says to change keepalive_timeout to 2 seconds but not sure why so not doing it for now

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig

sed -e 's|index index.html index.htm index.nginx-debian.html;|index index.html index.htm index.nginx-debian.html index.php;|g' -i /etc/nginx/sites-available/default
sed -e 's|#location ~ \\.php$ {|location ~ \\.php$ {|g' -i /etc/nginx/sites-available/default
sed -e 's|#\tinclude snippets/fastcgi-php.conf;|\tinclude snippets/fastcgi-php.conf;|g' -i /etc/nginx/sites-available/default
sed -e 's|#\tfastcgi_pass unix:/var/run/php5-fpm.sock;|\tfastcgi_pass unix:/var/run/php5-fpm.sock;\n\t}|g' -i /etc/nginx/sites-available/default
sed -e 's|#location ~ /\\.ht {|location ~ /\\.ht {|g' -i /etc/nginx/sites-available/default
sed -e 's|#\tdeny all;|\tdeny all;\n\t}|g' -i /etc/nginx/sites-available/default


cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.orig

sed -e 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=1|g' -i /etc/php5/fpm/php.ini

echo '<?php' >> /var/www/html/info.php
echo 'phpinfo();' >> /var/www/html/info.php
echo '?>' >> /var/www/html/info.php

sudo service nginx restart
sudo service nginx php5-fpm

