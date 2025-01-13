#!/bin/bash
# Create user with home directory
useradd -m -s /bin/bash pi-ccx

# Set password (using chpasswd to avoid prompt)
echo "pi-ccx:ccx%pi" | chpasswd

# Add user to necessary groups
usermod -aG sudo,adm,dialout,cdrom,audio,video,plugdev,games,users,input,netdev pi-ccx

# Configure auto-login via getty service
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/override.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi-ccx --noclear %I \$TERM
EOF

# Enable the getty service
systemctl enable getty@tty1.service