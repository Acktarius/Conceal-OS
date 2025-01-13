#!/bin/bash
echo "installing fail2ban"
apt install -y fail2ban
cd /etc/fail2ban
cp jail.conf jail.local
systemctl enable fail2ban