#!/bin/bash -eu

cd $(dirname $0)

echo "[i] install unzip make build-essential"
sudo apt update
sudo apt install -y unzip make build-essential

echo "[i] install gtp5g"
cd ~ ; wget -q https://github.com/free5gc/gtp5g/archive/refs/tags/v0.6.1.zip ; unzip v0.6.1.zip ; cd gtp5g-0.6.1 ; make ; sudo make install
cat /etc/modules | grep gtp5g
lsmod | grep gtp5g
