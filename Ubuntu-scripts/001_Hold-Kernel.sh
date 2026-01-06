#!/bin/bash

echo "===     001_Hold-Kernel.sh       ==="
echo "=== holding the kernel in place ==="
echo ""

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

# Detect the installed kernel version
echo "Detecting installed kernel version..."
INSTALLED_KERNEL=$(dpkg -l | grep -E '^ii.*linux-image-[0-9]' | awk '{print $2}' | head -1 | sed 's/linux-image-//')
if [ -z "$INSTALLED_KERNEL" ]; then
    echo "✗ Could not detect kernel version, using default 5.15.0-43-generic"
    INSTALLED_KERNEL="5.15.0-43-generic"
else
    echo "✓ Detected kernel: $INSTALLED_KERNEL"
fi

# Extract kernel version without -generic suffix for headers/modules
KERNEL_BASE=$(echo "$INSTALLED_KERNEL" | sed 's/-generic$//')

# Hold the kernel in place
echo "Holding kernel $INSTALLED_KERNEL and its modules..."
apt-mark hold linux-image-${INSTALLED_KERNEL} linux-headers-${KERNEL_BASE}-generic linux-modules-${KERNEL_BASE}-generic 2>/dev/null || \
apt-mark hold linux-image-${INSTALLED_KERNEL} 2>/dev/null
show_status "Kernel packages held"

# Remove HWE kernel and related packages (if present - usually not on server ISO)
echo "Checking for HWE kernel packages..."
if dpkg -l | grep -q "linux-generic-hwe-22.04"; then
    echo "Removing HWE kernel packages..."
    apt remove -y linux-generic-hwe-22.04
    show_status "HWE kernel removed"
else
    echo "✓ No HWE kernel packages found (expected on server ISO)"
fi

echo "Running autoremove..."
apt autoremove -y
show_status "Autoremove completed"

# Verify kernel version
echo "Verifying kernel version..."
KERNEL_OUTPUT=$(dpkg --list | grep linux-image)
echo "$KERNEL_OUTPUT"
show_status "Kernel version verification"

# Check for newer kernels (6.x) and purge if found (to keep LTS 5.15)
echo "Checking for newer kernels (6.x) that should be removed..."
if echo "$KERNEL_OUTPUT" | grep -q "linux-image-6\."; then
    NEWER_KERNELS=$(echo "$KERNEL_OUTPUT" | grep "linux-image-6\." | awk '{print $2}')
    for kernel in $NEWER_KERNELS; do
        echo "Found $kernel, purging..."
        dpkg --purge "$kernel" 2>/dev/null
        show_status "$kernel purged"
    done
else
    echo "✓ No 6.x kernels found (expected on server ISO)"
fi

# Verify holds
echo "Verifying kernel holds..."
apt-mark showhold
show_status "Kernel holds verification"

echo ""
echo "=== Kernel holding process completed ==="