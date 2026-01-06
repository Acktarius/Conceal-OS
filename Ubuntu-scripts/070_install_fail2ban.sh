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

echo "===     070_install_fail2ban.sh       ==="
echo "=== installing fail2ban ==="
echo ""

apt install -y fail2ban
show_status "fail2ban pre-installed"