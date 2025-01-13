#!/bin/bash
echo "installing assistant"
npm i -g nodemon
npm i -g livereload
cd /opt
git clone https://github.com/Acktarius/conceal-assistant.git
cd conceal-assistant
npm install
cp /opt/Conceal-OS/ingredients/etc/systemd/system/ccx-assistant.service /etc/systemd/system/ccx-assistant.service
chmod 664 /etc/systemd/system/ccx-assistant.service