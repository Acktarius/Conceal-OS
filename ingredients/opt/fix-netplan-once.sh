#!/bin/bash
# Don't use set -e - we want to continue even if some steps fail

# Wait a bit for interfaces to be available
sleep 3

# Find first non-loopback interface
IFACE=$(ip -o link show 2>/dev/null | awk -F': ' '!/lo/{print $2; exit}')

if [ -z "$IFACE" ]; then
    echo "Warning: No network interface found via ip, trying alternative detection..."
    IFACE=$(ls /sys/class/net/ 2>/dev/null | grep -v lo | head -1)
fi

if [ -z "$IFACE" ]; then
    echo "Warning: Could not detect network interface, will try to configure any available interface"
    # Don't exit - try to proceed with a generic config
fi

echo "Detected network interface: $IFACE"

# Disable cloud-init network management
mkdir -p /etc/cloud/cloud.cfg.d
echo 'network: {config: disabled}' > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# Disable network wait-online services to prevent boot blocking
systemctl disable systemd-networkd-wait-online.service || true
systemctl mask systemd-networkd-wait-online.service || true
systemctl disable NetworkManager-wait-online.service || true
systemctl mask NetworkManager-wait-online.service || true

# Create netplan configuration
if [ -n "$IFACE" ]; then
    cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ${IFACE}:
      dhcp4: true
      optional: true
EOF
else
    # Fallback: configure any interface matching common patterns
    cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: true
      optional: true
    enp0s3:
      dhcp4: true
      optional: true
    ens3:
      dhcp4: true
      optional: true
    any:
      match:
        name: en*
      dhcp4: true
      optional: true
EOF
fi

# Apply netplan
netplan generate || true
netplan apply || true

# Restart NetworkManager to pick up changes
systemctl restart NetworkManager || true

if [ -n "$IFACE" ]; then
    echo "Network configuration applied for interface: $IFACE"
else
    echo "Network configuration applied with fallback pattern matching"
fi

# Disable cloud-init services since we've taken over network management
systemctl disable cloud-init.service || true
systemctl disable cloud-init-local.service || true
systemctl disable cloud-config.service || true
systemctl disable cloud-final.service || true

# Disable this service so it doesn't run again
systemctl disable fix-netplan-once.service
