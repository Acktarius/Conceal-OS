#!/bin/bash

echo "===     000_Ubuntu_iso.sh       ==="
echo "=== preparing the field for apt ==="
echo ""

# Suspend needrestart for packer not to hang
export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

# Move original resolv.conf (points to system-resolved)
mv /etc/resolv.conf /etc/resolv.conf.orig

# Create our own resolv.conf with multiple DNS servers for redundancy
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
# Make sure it's readable
chmod 644 /etc/resolv.conf
# avoid host error
echo '127.0.1.1 ubuntu' >> /etc/hosts


# preparing the field for apt
apt-get update
apt-get install -y software-properties-common

# Add repositories properly
add-apt-repository -y main
add-apt-repository -y universe
add-apt-repository -y restricted
add-apt-repository -y multiverse

# keep the system minimal by installing only required packages, not recommended or suggested ones
echo 'APT::Get::Install-Recommends "0";' > /etc/apt/apt.conf.d/99norecommends
echo 'APT::Get::Install-Suggests "0";' >> /etc/apt/apt.conf.d/99norecommends