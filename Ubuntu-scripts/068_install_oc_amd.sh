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

echo "===     068_install_oc_amd.sh       ==="
echo "=== installing oc-amd ==="
echo ""

mkdir -p /opt/conceal-toolbox
cd /opt/conceal-toolbox
git clone https://github.com/Acktarius/oc-amd.git
cd oc-amd
chmod 755 *.sh
show_status "oc-amd installed"