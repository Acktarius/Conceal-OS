#!/bin/bash
echo "install Conceald... go get a coffee"
apt-get install -y build-essential python3-dev gcc g++ git cmake libboost-all-dev
cd /opt
git clone https://github.com/ConcealNetwork/conceal-core
cd conceal-core
mkdir build && cd build
cmake ..
make
cd