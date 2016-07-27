echo "This script must be run from the home directory of your non-root user"
read -n1 -r -p "Press any key to continue or ctrl-c to quit..." key
sudo apt-get -y install git
mkdir git
cd git
git clone https://github.com/scottclee/SKAD.git
cd ..
ln -s ./git/SKAD SKAD

cd SKAD/scripts

./configure_nginx.sh
./configure_php.sh
./configure_mongodb.sh

cd ..
# mv /var/www/html /var/www/html.orig
ln -s $PWD/website/skad /var/www/html/skad.io
ln -s $PWD/website/skad.dog /var/www/html/skad.dog
