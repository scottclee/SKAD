#!/bin/bash

read password

hexval=$(xxd -pu <<< "$password")

# PAM blanks out passwords for accounts that don't exist (to stop password leaks) so create a dummy account with that username so next time the password is captured the next time that userid is tried
if [[ $hexval == "080a" ]]; then

`useradd -M -s /bin/false $PAM_USER`

else 

# Get the git branch
GIT_BRANCH=`cd /home/pi/SKAD && /usr/bin/git branch`
INDEX=`awk -v a="$GIT_BRANCH" -v b="*" 'BEGIN{print index(a,b)}'`
INDEX=$(($INDEX + 1));
GIT_BRANCH=${GIT_BRANCH:INDEX};
STRLEN=${#GIT_BRANCH}
INDEX=`awk -v a="$GIT_BRANCH" -v b="\n" 'BEGIN{print index(a,b)}'`
if [ $INDEX == 0 ]; then
        INDEX=STRLEN
else
	INDEX=$(($INDEX - $STRLEN - 1));
fi
GIT_BRANCH=${GIT_BRANCH:0:INDEX};

URL="https://$GIT_BRANCH.skad.dog/attempt.php"

DATE=`date "+%Y%m%d"`
TIME_STAMP=`date "+%Y%m%d-%H%M%S"`
UNAME=`uname -a`

# The key should be stored in a local file if not then it is missing
KEYFILE=/home/pi/watch_dog.key
KEY_HASH=""

if [ ! -f $KEYFILE ]; then
	KEY_HASH="MISSING"
else
        KEY_HASH=`cat $KEYFILE`
fi

# See if the EXTERNALIP address has been cached from a previous call
FILE=/tmp/externalip.txt
EXTERNALIP=""

`find $FILE -mmin +1 -exec rm {} \;`

if [ ! -f $FILE ]; then
        EXTERNALIP=`curl -s http://ipecho.net/plain`
        echo $EXTERNALIP > $FILE
else
        EXTERNALIP=`cat $FILE`
fi

read -r -d '' JSON << EOM
{
	"timestamp": "$TIME_STAMP",
	"user": "$PAM_USER",
	"password": "$password",
	"ruser": "$PAM_RUSER",
	"rhost": "$PAM_RHOST",
	"service": "$PAM_SERVICE",
	"TTY": "$PAM_TTY",
	"uname": "$UNAME",
	"externalip": "$EXTERNALIP",
	"key": "$KEY_HASH"
}
EOM

LOG_ENTRY="$KEY_HASH, $TIME_STAMP, $PAM_USER, $password, $PAM_RUSER, $PAM_RHOST, $PAM_SERVICE, $PAM_TTY, $UNAME"

echo "URL: $URL" >> /var/log/skad_dog.log
echo "$LOG_ENTRY" >> /var/log/skad_dog.log

JSON_FILE="/tmp/json.$TIME_STAMP.$RANDOM"
echo "$JSON" > $JSON_FILE
CMD="curl -i -X POST -d @$JSON_FILE $URL"
`$CMD` &> /dev/null
`rm $JSON_FILE`

fi

