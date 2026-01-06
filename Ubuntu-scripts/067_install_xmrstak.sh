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

echo "===     067_install_xmrstak.sh       ==="
echo "=== installing xmr-stak ==="
echo ""

apt install -y ocl-icd-opencl-dev libmicrohttpd-dev libssl-dev libhwloc-dev pkg-config libjsoncpp-dev libwxgtk3.0-gtk3-dev
cd /opt
wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.16.tar.gz
tar -xvf libmicrohttpd-0.9.16.tar.gz
cd libmicrohttpd-0.9.16
./configure
make
make install
cd ..
wget https://download.open-mpi.org/release/hwloc/v2.8/hwloc-2.8.0.tar.gz
tar -xvf hwloc-2.8.0.tar.gz
cd hwloc-2.8.0
./configure
make
make install
cd ..
rm *.gz
git clone https://github.com/Acktarius/xmr-stak.git || {
    echo "✗ git clone failed"
    exit 1
}
cd xmr-stak || {
    echo "✗ Failed to cd into xmr-stak"
    exit 1
}
# Structure is /opt/xmr-stak/xmrstak/donate-level.hpp
if [ -d "xmrstak" ]; then
    cd xmrstak || {
        echo "✗ Failed to cd into xmr-stak/xmrstak"
        exit 1
    }
    # Set donation level to 0.9%
    echo "Setting donation level to 0.9%..."
    if [ -f "donate-level.hpp" ]; then
        sed -i 's/.*constexpr double fDevDonationLevel =.*/constexpr double fDevDonationLevel = 0.9 \/ 100.0;/' donate-level.hpp
        show_status "Donation level set to 0.9%"
    else
        echo "✗ donate-level.hpp not found in xmr-stak/xmrstak/"
    fi
    cd ..
else
    echo "⚠ xmr-stak subdirectory not found, skipping donation level modification"
fi
# ubuntu_AMD_builder.sh should be in /opt/xmr-stak
echo "Checking for ubuntu_AMD_builder.sh..."
pwd
ls -la | grep -i ubuntu || echo "No ubuntu files found in current directory"
if [ -f "ubuntu_AMD_builder.sh" ]; then
    echo "Found ubuntu_AMD_builder.sh, making it executable..."
    chmod +x ubuntu_AMD_builder.sh
    echo "Executing ubuntu_AMD_builder.sh from $(pwd)..."
    set -e  # Exit on error
    bash -x ubuntu_AMD_builder.sh  # -x for debug output
    BUILD_EXIT=$?
    set +e  # Disable exit on error
    if [ $BUILD_EXIT -ne 0 ]; then
        echo "✗ ubuntu_AMD_builder.sh failed with exit code $BUILD_EXIT"
        show_status "xmr-stak installation failed"
        exit 1
    fi
    show_status "xmr-stak installed"
else
    echo "✗ ubuntu_AMD_builder.sh not found in $(pwd)"
    echo "Contents of current directory:"
    ls -la
    show_status "xmr-stak installation failed"
fi

echo "=== mem-alloc-fail_solver ==="
echo "=== installing mem-alloc-fail_solver ==="
echo ""
mkdir -p /opt/conceal-toolbox
cd /opt/conceal-toolbox
git clone https://github.com/Acktarius/mem-alloc-fail_solver.git
cd mem-alloc-fail_solver
chmod 755 mem_alloc_fail-solver.sh
./mem_alloc_fail-solver.sh
show_status "mem-alloc-fail_solver installed"
echo ""

echo "=== ccx-mining_service ==="
echo ""
if [ -f /opt/ingredients/etc/systemd/system/ccx-mining.service ]; then
  cp /opt/ingredients/etc/systemd/system/ccx-mining.service /etc/systemd/system/ccx-mining.service
  chmod 664 /etc/systemd/system/ccx-mining.service
  show_status "ccx-mining_service pre-set"
else
  echo "✗ /opt/ingredients/etc/systemd/system/ccx-mining.service not found"
fi
echo ""
