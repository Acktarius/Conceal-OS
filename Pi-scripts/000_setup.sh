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
# Update package sources for Ubuntu ARM
cat > /etc/apt/sources.list << EOF
deb http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted universe multiverse
EOF

# Move resolve.conf since we are running in chroot and systemd services cannot run in it.
mv /etc/resolv.conf /etc/resolv.conf.orig # points to system-resolved

# Create our own resolv.conf with multiple DNS servers for redundancy
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
# Make sure it's readable
chmod 644 /etc/resolv.conf

echo '127.0.1.1 raspberrypi' >> /etc/hosts