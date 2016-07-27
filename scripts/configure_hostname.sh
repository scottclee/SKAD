###################################################################
# Change the DNS hostname (which can be used to contact it over wifi)

if [ -z "$1" ]; then
   echo "Parameters: <hostname>"
   exit 1
fi

cp /etc/hostname /etc/hostname.orig
echo $1 > /etc/hostname

cp /etc/hosts /etc/hosts.orig
sed -e 's/raspberrypi/'$1'/g' -i /etc/hosts

