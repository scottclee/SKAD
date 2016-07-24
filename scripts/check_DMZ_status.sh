#!/bin/bash

TIME_STAMP=`date "+%Y%m%d-%H%M%S"`
HOSTNAME=`cat /etc/hostname`
#echo ">>>>>>>>>>>>>>>>>" >> /tmp/skad.dog.txt
#echo "TIME_STAMP: $TIME_STAMP" >> /tmp/skad.dog.txt

EXTERNALIP=`curl -s http://ipecho.net/plain`

echo $TIME_STAMP > /var/www/html/hi.html

RESULT="`wget -qO- http://$EXTERNALIP/hi.html`"

DMZ=""

if [ "$TIME_STAMP" != "$RESULT" ]; then
	# Not in DMZ so make sure checks are done every minute from now on
	`crontab -l | grep -v 'check_DMZ_status.sh' | crontab -`
	`crontab -l | { cat; echo "* * * * * /home/pi/SKAD/scripts/check_DMZ_status.sh"; } | crontab -`
	#echo "NOT IN DMZ" >> /tmp/dog.txt
	#echo "TIME_STAMP: [$TIME_STAMP]" >> /tmp/dog.txt
	#echo "RESULT:     [$RESULT]" >> /tmp/dog.txt
	DMZ="N"
else
	# Handshake is successful so we are in the DMZ!!
	# Reduce frequence of handshake to midnight every day
	`crontab -l | grep -v 'check_DMZ_status.sh' | crontab -`
	`crontab -l | { cat; echo "00 00 * * * /home/pi/SKAD/scripts/check_DMZ_status.sh"; } | crontab -`
	echo "IN DMZ" >> /tmp/dog.txt
	DMZ="Y"
fi

#echo "DMZ: $DMZ" >> /tmp/skad.dog.txt

# The key should be stored in a local file if not then it is missing
KEYFILE=/home/pi/watch_dog.key
KEY_HASH=""

if [ ! -f $KEYFILE ]; then
	KEY_HASH="MISSING"
else
        KEY_HASH=`cat $KEYFILE`
fi

#echo "KEY_HASH: $KEY_HASH" >> /tmp/skad.dog.txt

# Get the git branch
GIT_BRANCH=`cd /home/pi/SKAD && /usr/bin/git branch`

INDEX=`awk -v a="$GIT_BRANCH" -v b="*" 'BEGIN{print index(a,b)}'`
INDEX=$(($INDEX + 1));
GIT_BRANCH=${GIT_BRANCH:INDEX};
STRLEN=${#GIT_BRANCH}
#echo "STRLEN: $STRLEN" >> /tmp/skad.dog.txt
INDEX=`awk -v a="$GIT_BRANCH" -v b="\n" 'BEGIN{print index(a,b)}'`
#echo "INDEX (before): $INDEX" >> /tmp/skad.dog.txt
INDEX=$(($INDEX - $STRLEN - 1));
#echo "INDEX (after): $INDEX" >> /tmp/skad.dog.txt
GIT_BRANCH=${GIT_BRANCH:0:INDEX};
#echo "GIT_BRANCH: $GIT_BRANCH" >> /tmp/skad.dog.txt

read -r -d '' JSON << EOM
{
	"timestamp": "$TIME_STAMP",
	"externalip": "$EXTERNALIP",
	"name": "$HOSTNAME",
	"key": "$KEY_HASH",
	"DMZ": "$DMZ"
}
EOM

URL="https://$GIT_BRANCH.skad.dog/DMZstatus.php"
JSON_FILE="/tmp/json.$TIME_STAMP.$RANDOM"
echo "$JSON" > $JSON_FILE
CMD="curl -i -X POST -d @$JSON_FILE $URL"
`$CMD` &> /dev/null
`rm $JSON_FILE`

#echo "URL: $URL" >> /tmp/skad.dog.txt
#echo "JSON: $JSON" >> /tmp/skad.dog.txt

