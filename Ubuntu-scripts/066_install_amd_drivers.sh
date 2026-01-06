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
amdgpu-install -y --accept-eula --no-dkms --usecase=opencl --opencl=rocr
show_status "amd drivers installed"