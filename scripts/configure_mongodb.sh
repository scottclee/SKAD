apt-get -y install mongodb-server
apt-get -y install php-pear php5-dev
# TODO Automate the following command as it prompts the user for response
pecl install mongo
echo "extension=mongo.so" >> /etc/php5/fpm/php.ini
