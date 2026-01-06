#!/bin/bash

export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

# Function to show status
show_status() {
    if [ $? -eq 0 ]; then
        echo "✓ $1"
    else
        echo "✗ $1"
    fi
}

echo "===     002_apt.sh       ==="
echo "=== installing apt packages ==="
echo ""

# Clean apt cache first to free space
apt-get clean
rm -rf /var/lib/apt/lists/*

# APT update only
echo "APT update only..."
apt-get update
show_status "APT update"

# Note: ubiquity and ubiquity-frontend-gtk removed - not needed for server ISO
# Server ISO uses subiquity/autoinstall, not ubiquity

echo "firmware and drivers"
apt install -y \
    linux-firmware \
    amd64-microcode \
    xserver-xorg-video-amdgpu \
    network-manager \
    linux-modules-extra-$(uname -r) || true

# Ensure network-manager starts on boot
# NetworkManager will take over from cloud-init after first boot
systemctl enable NetworkManager
systemctl start NetworkManager || true

# Configure NetworkManager to manage all interfaces
cat > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf <<EOF
[keyfile]
unmanaged-devices=none
EOF

# Install additional GPU support
apt install -y \
    mesa-vulkan-drivers \
    libvulkan1 \
    vulkan-tools \
    vulkan-validationlayers

 # Prevent cryptsetup warnings
echo "CRYPTSETUP=n" >> /etc/initramfs-tools/conf.d/cryptsetup

# echo "remove language surplus"
# apt remove -y language-pack-pt language-pack-pt-base
#show_status "language surplus removed"

echo "install or remove tiny software"
apt install -y \
    git \
    clinfo \
    lm-sensors \
    curl \
    dbus-x11 \
    jq \
    mesa-utils \
    cloud-guest-utils \
    build-essential \
    net-tools \
    cmake

# apt-get install -y xfce4 lightdm lightdm-gtk-greeter
# echo "lightdm shared/default-x-display-manager select lightdm" | debconf-set-selections
# systemctl enable lightdm
# openssh-server already installed via cloud-config user-data, but ensure it's enabled
systemctl enable ssh
systemctl restart ssh
show_status "SSH enabled"
