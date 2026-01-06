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

echo "===     010_nodejs.sh       ==="
echo "===   installing nodejs     ==="
echo ""

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs
show_status "nodejs installed"

npm install -g npm@latest
show_status "npm updated to latest"

