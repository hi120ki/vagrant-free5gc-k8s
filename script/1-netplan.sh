#!/bin/bash -eu

cd $(dirname $0)

echo "[i] install jq"
sudo apt update
sudo apt install -y jq

echo "[i] apply netplan config"
ip a | grep enp0s8 >/dev/null 2>&1
if [ $? = 0 ]; then
eth0addr=$(ip -j a | jq -r '.[] | select(.ifname == "enp0s8") | .address')
eth0ip=$(ip -j a | jq -r '.[] | select(.ifname == "enp0s8") | .addr_info[] | select(.family == "inet") | .local')
eth0prefix=$(ip -j a | jq -r '.[] | select(.ifname == "enp0s8") | .addr_info[] | select(.family == "inet") | .prefixlen')

sudo tee /etc/netplan/50-vagrant.yaml <<EOF >/dev/null
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
      - $eth0ip/$eth0prefix
      match:
        macaddress: $eth0addr
      set-name: eth0
EOF
fi

ip a | grep enp0s3 >/dev/null 2>&1
if [ $? = 0 ]; then
eth1addr=$(ip -j a | jq -r '.[] | select(.ifname == "enp0s3") | .address')

sudo tee /etc/netplan/50-cloud-init.yaml <<EOF >/dev/null
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: true
      match:
        macaddress: $eth1addr
      set-name: eth1
EOF
fi

echo "[i] netplan apply"
sudo netplan apply

echo "[i] show ip address"
ip address
