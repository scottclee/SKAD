EXTERNALIP=`curl -s http://ipecho.net/plain`
TIME_STAMP=`date "+%Y%m%d-%H%M%S"`

echo $TIME_STAMP > /var/www/html/hi.html

RESULT="`wget -qO- http://$EXTERNALIP/hi.html`"


if [ "$TIME_STAMP" != "$RESULT" ]; then
	# Not in DMZ
	echo "NOT IN DMZ" >> /tmp/dog.txt
	echo "TIME_STAMP: [$TIME_STAMP]" >> /tmp/dog.txt
	echo "RESULT:     [$RESULT]" >> /tmp/dog.txt
else
	# Handshake is successful so we are in the DMZ!!
	# Stop the handshake process
	`crontab -l | grep -v 'check_DMZ_status.sh' | crontab -`
	echo "IN DMZ" >> /tmp/dog.txt
fi


