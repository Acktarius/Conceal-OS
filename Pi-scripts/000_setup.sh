#!/bin/bash

# enable SSH
touch /boot/ssh

# add temporary password
#echo 'pi:r3notaRE' | chpasswd

# enable zswap with default settings
sed -i -e 's/$/ zswap.enabled=1/' /boot/cmdline.txt

# Move corrupted sources file
if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
    mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
fi

# Move resolve.conf since we are running in chroot and systemd services cannot run in it.
mv /etc/resolv.conf /etc/resolv.conf.orig # points to system-resolved

# Create our own resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf >/dev/null


echo '127.0.1.1 raspberrypi' >> /etc/hosts