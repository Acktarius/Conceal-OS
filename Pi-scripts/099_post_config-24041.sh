#!/bin/bash

# Cleaning
rm -rf /opt/Conceal-OS

# Install cloud-init
apt-get install -y cloud-init

# Configure cloud-init for disk expansion
cat > /etc/cloud/cloud.cfg.d/99_resize.cfg << EOF
growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false
EOF

# Enable cloud-init services
systemctl enable cloud-init.service
systemctl enable cloud-init-local.service
systemctl enable cloud-config.service
systemctl enable cloud-final.service

# Remove the temp resolv.conf file created to access network in chroot
rm -rf /etc/resolv.conf
mv /etc/resolv.conf.orig /etc/resolv.conf # bring back original
