mv /var/www/html /var/www/html.orig
ln -s /home/pi/SKAD/html/guarddog.unsecure /var/www/html
#I believe the symbolic link is now stored in git
#ln -s /home/pi/SKAD/php /var/www/html/php
gcc ../c/wrapper.c -o /home/pi/php_root
chown root /home/pi/php_root
chmod u=rwx,go=xr,+s /home/pi/php_root
