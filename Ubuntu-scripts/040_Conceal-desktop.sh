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

echo "===     040_Conceal-desktop.sh       ==="
echo "===   installing conceal-desktop     ==="
echo ""

# Install conceal-desktop dependencies
echo "Installing dependencies..."
apt install git gcc make cmake libboost-all-dev qtbase5-dev libqt5charts5-dev
show_status "Dependencies installed"

# Clone conceal-desktop and checkout development branch
echo "Cloning conceal-desktop..."
cd /opt
git clone https://github.com/ConcealNetwork/conceal-desktop
cd conceal-desktop
git checkout development
show_status "Conceal-desktop cloned and development branch checked out"

# Remove existing cryptonote directory and add as subtree
echo "Setting up conceal-core as subtree..."
rm -rf cryptonote
git subtree add --prefix=cryptonote https://github.com/ConcealNetwork/conceal-core development --squash
show_status "Conceal-core added as subtree"

# Build conceal-desktop
echo "Building conceal-desktop..."
make build-release
show_status "Conceal-desktop built"

# Create bin directory and move executable
echo "Setting up binary..."
mkdir -p bin && mv build/release/conceal-desktop bin/
show_status "Binary moved to bin directory"

# Clean build files
echo "Cleaning build files..."
make clean
show_status "Build files cleaned"

# set icon
echo "Setting up icon..."
cd /etc/skel
mkdir -p .icons
mkdir -p .local/share/applications
if [ -f /opt/ingredients/etc/skel/.icons/conceal.png ]; then
  mv /opt/ingredients/etc/skel/.icons/conceal.png .icons/conceal.png
  show_status "Icon set"
else
  echo "✗ /opt/ingredients/etc/skel/.icons/conceal.png not found"
fi

if [ -f /opt/ingredients/etc/skel/.local/share/applications/conceal-desktop.desktop ]; then
  cp /opt/ingredients/etc/skel/.local/share/applications/conceal-desktop.desktop .local/share/applications/conceal-desktop.desktop
  show_status "Desktop file set"
else
  echo "✗ /opt/ingredients/etc/skel/.local/share/applications/conceal-desktop.desktop not found"
fi

echo ""
echo "=== Conceal-desktop installation completed ==="