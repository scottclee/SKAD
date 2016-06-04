bash ./variables.sh
# ./install_some_packages_early_temp_fix.sh
./configure_core.sh
./configure_nginx.sh
./configure_php.sh
./configure_cpanJson.sh
./configure_webservices.sh
./configure_headlesswifisetup.sh
./configure_letsencrypt.sh
./configure_hostname.sh $REVERSE_PROXY_BRANDING
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /home/pi/SKAD/files/guarddog.unsecure/default /etc/nginx/sites-available/
echo "Please reboot me now"
