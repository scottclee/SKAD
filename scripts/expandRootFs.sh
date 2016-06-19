#!/bin/bash
if [ ! -f /var/rootfs-expanded ]; then
    raspi-config --expand-rootfs
    touch /var/rootfs-expanded
    echo "#####################################"
    echo "Rebooting pi to continue installation"
    echo "#####################################"
    reboot
fi


