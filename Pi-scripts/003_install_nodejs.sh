#!/bin/bash
echo "install nodejs"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt install -y nodejs
apt install -y npm
npm install -g npm@latest