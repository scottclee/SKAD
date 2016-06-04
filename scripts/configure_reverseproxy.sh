# ./install_some_packages_early_temp_fix.sh
./configure_core.sh
./configure_letsencrypt.sh
./configure_nginx.sh
./configure_php.sh
./configure_cpanJson.sh
./configure_webservices.sh
./configure_headlesswifisetup.sh
./configure_hostname.sh defenderdog
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /home/pi/SKAD/files/guarddog/default /etc/nginx/sites-available/
echo "Please reboot me now"
