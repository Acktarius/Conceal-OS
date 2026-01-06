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

echo "===     069_install_ping_ccx_pool.sh       ==="
echo "=== installing ping_ccx_pool_cpp ==="
echo ""

mkdir -p /home/conceal/Desktop || true
mkdir -p /etc/skel/Desktop || true

apt install -y build-essential cmake libwxgtk3.0-gtk3-dev git nlohmann-json3-dev nmap
git clone https://github.com/Acktarius/ping_ccx_pool_cpp.git
cd ping_ccx_pool_cpp
mkdir build && cd build
cmake -DINSTALL_POLKIT_POLICY=ON ..
cmake --build .
# cmake --install .
show_status "ping_ccx_pool_cpp build"