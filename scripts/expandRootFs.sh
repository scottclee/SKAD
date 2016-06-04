#!/bin/bash
if [ ! -f /var/rootfs-expanded ]; then
    raspi-config --expand-rootfs
    touch /var/rootfs-expanded
    echo "\n Rebooting pi before continuing installation"
    reboot
fi


