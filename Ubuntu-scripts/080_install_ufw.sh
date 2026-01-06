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

echo "===     080_install_ufw.sh       ==="
echo "=== installing ufw ==="
echo ""

apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 16000/tcp  # Conceal port
ufw allow 3500/tcp  # Conceal assistant port
ufw --force enable
show_status "ufw installed"