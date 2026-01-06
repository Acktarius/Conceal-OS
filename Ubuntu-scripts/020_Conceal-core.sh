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

echo "===     020_Conceal-core.sh       ==="
echo "=== installing conceal-core ==="
echo ""

# Install conceal-core
apt-get install -y build-essential python3-dev gcc g++ git cmake libboost-all-dev
cd /opt
git clone https://github.com/ConcealNetwork/conceal-core
# cd conceal-core
# mkdir build && cd build
# cmake ..
#make
show_status "conceal-core downloaded"
