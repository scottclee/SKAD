#!/bin/bash

# The magic bit that catches failed logins
cp /etc/pam.d/common-auth /etc/pam.d/common-auth.orig
sed -e 's|auth    [success=1 default=ignore]      pam_unix.so nullok_secure|auth    [success=2 default=ignore]      pam_unix.so nullok_secure\nauth    optional        pam_exec.so expose_authtok /home/pi/SKAD/scripts/register_attempt.sh|g' -i /etc/pam.d/common-auth

# Add clean up job to keep rolling log of 31 days
line="00 00 * * * /home/pi/SKAD/scripts/remove_oldattemptsfromlog.sh"
(crontab -u pi -l; echo "$line" ) | crontab -u pi -

./create_dummyaccounts.sh
