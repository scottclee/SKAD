sudo apt-get update
sudo apt-get install psad
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -j LOG
sudo iptables -A FORWARD -j LOG
sudo iptables -A INPUT -j DROP
sudo apt-get install iptables-persistent
sudo service iptables-persistent start
sudo cp /etc/psad/psad.conf /etc/psad/psad.orig
sudo cp /home/pi/SKAD/scripts/psad.conf /etc/psad/psad.conf
sudo psad --sig-update
sudo service psad restart
sudo su -
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/5 * * * * sudo /home/pi/SKAD/scripts/portscancheck.sh" >> mycron
#install new cron file
crontab mycron
rm mycron


