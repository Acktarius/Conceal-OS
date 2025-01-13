#!/bin/bash
echo "installing guardian"
cd /opt
git clone https://github.com/ConcealNetwork/conceal-guardian.git
cd conceal-guardian
npm install
cd
cp /opt/Conceal-OS/ingredients/opt/conceal-guardian/config.json /opt/conceal-guardian/config.json
chmod 664 /opt/conceal-guardian/config.json
cp /opt/Conceal-OS/ingredients/etc/systemd/system/ccx-guardian.service /etc/systemd/system/ccx-guardian.service
chmod 664 /etc/systemd/system/ccx-guardian.service