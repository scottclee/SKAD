# I've observed some sort of network problems when installing packages so going to put them all in one script and make it the first one called. If it fails then I will get the script to end
# I'll still leave the package installs in the individual scripts just incase they want to be used stand alone or incase I miss any!!

apt-get -y update

if [ ! $? -eq 0 ]; then
    echo Command failed
    exit
fi

apt-get -y upgrade

if [ ! $? -eq 0 ]; then
    echo Command failed
    exit
fi

apt-get -y install libssl-dev cpanminus git vim udhcpd bc nginx php5-fpm 

if [ ! $? -eq 0 ]; then
    echo Command failed
    exit
fi
