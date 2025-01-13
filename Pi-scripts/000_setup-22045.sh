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

# Create our own resolv.conf with multiple DNS servers for redundancy
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
# Make sure it's readable
chmod 644 /etc/resolv.conf
# avoid host error
echo '127.0.1.1 raspberrypi' >> /etc/hosts

# preparing the field for apt
apt-get update
apt-get install -y software-properties-common

# Add repositories properly
add-apt-repository -y main
add-apt-repository -y universe
add-apt-repository -y restricted
add-apt-repository -y multiverse

