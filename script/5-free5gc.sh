#!/bin/bash -eu

cd $(dirname $0)

echo "[i] create namespace"
kubectl create namespace free5gc

echo "[i] add helm repo"
helm repo add towards5gs 'https://raw.githubusercontent.com/Orange-OpenSource/towards5gs-helm/main/repo/'
helm repo update

echo "[i] add persistent volume"
mkdir -p /home/vagrant/kubedata
kubectl apply -f /vagrant/conf/persistent.yml

echo "[i] install free5gc"
git clone https://github.com/Orange-OpenSource/towards5gs-helm.git ~/towards5gs-helm
helm -n free5gc install free5gc-v1 ~/towards5gs-helm/charts/free5gc

c1=$(kubectl get pods -n free5gc | grep -c "Running")
while [ $c1 -ne 11 ]
do
  sleep 1
  echo "[i] waiting..."
  c1=$(kubectl get pods -n free5gc | grep -c "Running")
done
sleep 3
echo "[+] install free5gc done"
