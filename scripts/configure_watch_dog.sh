#!/bin/bash

# Install Web server in order to do DMZ check
./configure_nginx.sh

# The magic bit that catches failed logins
cp /etc/pam.d/common-auth /etc/pam.d/common-auth.orig
sed -i "/success=1 default=ignore/c\auth\t[success=2 default=ignore]\tpam_unix.so nullok_secure\nauth\toptional\tpam_exec.so expose_authtok \/home\/pi\/SKAD\/scripts\/register_attempt.sh" /etc/pam.d/common-auth

# Add clean up job to keep rolling log of 31 days
line="00 00 * * * /home/pi/SKAD/scripts/remove_oldattemptsfromlog.sh"
(crontab -u pi -l; echo "$line" ) | crontab -u pi -

<<<<<<< HEAD:scripts/configure_skad_dog.sh
./create_dummyaccounts.sh

# Add the DMZ check to run every minute
`crontab -l | { cat; echo "* * * * * /home/pi/SKAD/scripts/check_DMZ_status.sh"; } | crontab -`
=======
# ./create_dummyaccounts.sh

echo "Please enter the name of this new born Watch Dog:"
read dogname

./configure_hostname.sh $dogname

echo "Change password so it is no longer the default one:"
/usr/bin/passwd pi

echo "##############################################################"
echo "This dog's details are as follows:"

./generate_unique_key.sh

echo "Name: $dogname"
echo "##############################################################"

echo "Now reboot this machine"
>>>>>>> test:scripts/configure_watch_dog.sh
