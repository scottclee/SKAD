apt-get -y install git bc

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

/opt/letsencrypt/letsencrypt-auto --dry-run --config /home/pi/SKAD/files/guarddog/cli.ini certonly --standalone -d scottshouse.redirectme.net

# When executed from the web page the letsencrypt command actually runs under the www-data user and so sees is home directory as /var/www which means it does not find the letsencrypt install and tries to run it again. So creating a symbolic link to the one in the root directory
/bin/ln -s /root/.local /var/www/.local

cp /home/pi/SKAD/files/guarddog.unsecure/cli.ini /etc/letsencrypt/ 
