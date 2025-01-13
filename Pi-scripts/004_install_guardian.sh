#!/bin/bash
echo "installing guardian"
cd /opt
git clone https://github.com/ConcealNetwork/conceal-guardian.git
cd conceal-guardian
npm install
cd
cp /opt/Conceal-OS/ingredients/opt/conceal-guardian/config.json /opt/conceal-guardian/config.json