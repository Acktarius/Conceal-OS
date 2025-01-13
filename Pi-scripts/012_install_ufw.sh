#!/bin/bash
echo "installing ufw"
apt install -y ufw
ufw allow ssh
ufw allow from 192.168.1.0/24 to any port 8080
ufw allow 15000  # Conceal port    
ufw allow 16000  # Conceal port
ufw allow 3500 # Conceal-Assistant port
echo "    PermitRootLogin no" >> /etc/ssh/ssh_config