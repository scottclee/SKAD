if [ -z "$1" ]; then
   echo "Parameters: <branch name>"
   exit 1
fi

branch=$1
cd /home/pi
rm -fr SKAD-${branch}
rm SKAD
wget https://github.com/scottclee/SKAD/archive/${branch}.zip
unzip ${branch}.zip
rm ${branch}.zip
ln -s SKAD-${branch} SKAD
chmod +x SKAD/scripts/*.sh
sudo ./SKAD/scripts/expandRootFs.sh

