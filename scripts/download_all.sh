#!/bin/bash
cd /home/pi
mkdir git
cd git
git clone https://github.com/scottclee/SKAD.gi
cd /home/pi
ln -s ./git/SKAD SKAD
sudo ./SKAD/scripts/expandRootFs.sh

###############################################################
# Note: Changing all this so it actually clones the code base instead of just downloading it. This should speed up the ability to make changes on directly on the pi if necessary

#if [ -z "$1" ]; then
#   echo "Parameters: <branch name>"
#   exit 1
#fi

#branch=$1
#cd /home/pi
#rm -fr SKAD-${branch}
#rm SKAD
#wget https://github.com/scottclee/SKAD/archive/${branch}.zip
#unzip ${branch}.zip
#rm ${branch}.zip
#ln -s SKAD-${branch} SKAD
#chmod +x SKAD/scripts/*.sh


