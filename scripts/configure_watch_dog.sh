#!/bin/bash

# The magic bit that catches failed logins
cp /etc/pam.d/common-auth /etc/pam.d/common-auth.orig
sed -i "/success=1 default=ignore/c\auth\t[success=2 default=ignore]\tpam_unix.so nullok_secure\nauth\toptional\tpam_exec.so expose_authtok \/home\/pi\/SKAD\/scripts\/register_attempt.sh" /etc/pam.d/common-auth

# Add clean up job to keep rolling log of 31 days
line="00 00 * * * /home/pi/SKAD/scripts/remove_oldattemptsfromlog.sh"
(crontab -u pi -l; echo "$line" ) | crontab -u pi -

# ./create_dummyaccounts.sh

echo "Please enter the name of this new born Watch Dog:"
read dogname

./configure_hostname.sh $dogname

echo "Change password so it is no longer the default one:"
/usr/bin/passwd pi

echo "Now reboot this machine"
