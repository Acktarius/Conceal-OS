#!/bin/bash

rm -rf /opt/Conceal-OS
# force automatic rootfs expansion on first boot:
# https://forums.raspberrypi.com/viewtopic.php?t=174434#p1117084
wget -O /etc/init.d/resize2fs_once https://raw.githubusercontent.com/RPi-Distro/pi-gen/master/stage2/01-sys-tweaks/files/resize2fs_once
chmod +x /etc/init.d/resize2fs_once
systemctl enable resize2fs_once

# Remove the temp resolv.conf file created to access network in chroot
rm -rf /etc/resolv.conf
mv /etc/resolv.conf.orig /etc/resolv.conf # bring back original
