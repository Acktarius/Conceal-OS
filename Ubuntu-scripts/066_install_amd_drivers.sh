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

echo "===     066_install_amd_drivers.sh       ==="
echo "=== installing amd drivers ==="
echo ""

cd /tmp
wget https://repo.radeon.com/amdgpu-install/22.40.3/ubuntu/jammy/amdgpu-install_5.4.50403-1_all.deb
apt-get install ./amdgpu-install_5.4.50403-1_all.deb
# rm amdgpu-install_5.4.50403-1_all.deb
cd

# Install kernel headers needed for DKMS
apt-get install -y linux-headers-$(uname -r) build-essential

# Use DKMS for physical hardware compatibility (remove --no-dkms)
amdgpu-install -y --accept-eula --usecase=opencl --opencl=rocr
show_status "amd drivers installed with DKMS"

# Verify DKMS modules are built
echo "Verifying DKMS modules..."
dkms status | grep amdgpu || echo "Warning: DKMS modules may not be built yet"
show_status "DKMS verification"

# Update initramfs to include AMD driver modules for physical hardware boot
echo "Updating initramfs with AMD driver modules..."
update-initramfs -u -k all
show_status "initramfs updated"