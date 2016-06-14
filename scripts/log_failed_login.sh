#!/bin/bash

# The password is passed into the script via stdin
read password

# PAM blats passwords for accounts that don't exist (to stop password leaks).
# So get hex value of the password and compare against the dummy value
hexval=$(xxd -pu <<< "$password")

if [[ $hexval == "080a" ]]; then

# Create a new user with the username so next time the password is captured the next time that userid is tried
`useradd -M -s /bin/false $PAM_USER`
#echo "Creating new user: $PAM_USER" >> /tmp/password.txt

else 

URL="https://skad.dog/attemptedlogin"
DATE=`date "+%Y%m%d"`
TIME_STAMP=`date "+%Y%m%d-%H%M%S"`
UNAME=`uname -a`
# The key should be stored in a local file
KEY="abcdefg"

read -r -d '' JSON << EOM
{
	"timestamp": "$TIME_STAMP",
	"user": "$PAM_USER",
	"password": "$password",
	"ruser": "$PAM_RUSER",
	"rhost": "$PAM_RHOST",
	"service": "$PAM_SERVICE",
	"TTY": "$PAM_TTY",
	"uname": "$UNAME"
	"key": "$KEY"
}
EOM

LOG_ENTRY="$TIME_STAMP, $PAM_USER, $password, $PAM_RUSER, $PAM_RHOST, $PAM_SERVICE, $PAM_TTY, $UNAME"

#curl -X POST $URL -d '$JSON'
echo "$LOG_ENTRY" >> /var/log/skad_dog.log

fi
