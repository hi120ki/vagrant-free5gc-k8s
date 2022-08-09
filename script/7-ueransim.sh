#!/bin/bash -eu

cd $(dirname $0)

helm -n free5gc install ueransim-v1 /vagrant/towards5gs-helm/charts/ueransim/

c1=$(kubectl get pods -n free5gc | grep -c "Running")
while [ $c1 -ne 13 ]
do
  sleep 1
  echo "[i] waiting install ueransim"
  c1=$(kubectl get pods -n free5gc | grep -c "Running")
done

for i in {10..1}; do
  echo "[i] waiting install ueransim $i"
  sleep 1
done

echo "[i] show host ip address"
ip address

export UPF_POD_NAME=$(kubectl get pods --namespace free5gc -l "nf=upf" -o jsonpath="{.items[0].metadata.name}")
export AMF_POD_NAME=$(kubectl get pods --namespace free5gc -l "nf=amf" -o jsonpath="{.items[0].metadata.name}")
export SMF_POD_NAME=$(kubectl get pods --namespace free5gc -l "nf=smf" -o jsonpath="{.items[0].metadata.name}")
export GNB_POD_NAME=$(kubectl get pods --namespace free5gc -l "component=gnb" -o jsonpath="{.items[0].metadata.name}")
export UE_POD_NAME=$(kubectl get pods --namespace free5gc -l "component=ue" -o jsonpath="{.items[0].metadata.name}")

echo "[i] UPF ip route"
kubectl --namespace free5gc exec -it $UPF_POD_NAME -- ip route show table all

echo "[i] UPF log"
kubectl --namespace free5gc logs $UPF_POD_NAME

echo "[i] AMF log"
kubectl --namespace free5gc logs $AMF_POD_NAME

echo "[i] SMF log"
kubectl --namespace free5gc logs $SMF_POD_NAME

echo "[i] GNB log"
kubectl --namespace free5gc logs $GNB_POD_NAME

echo "[i] UE log"
kubectl --namespace free5gc logs $UE_POD_NAME

echo "[i] UE ip address"
kubectl --namespace free5gc exec -it $UE_POD_NAME -- ip address

echo "[i] UE ping check"
kubectl --namespace free5gc exec -it $UE_POD_NAME -- bash -c 'ping -c 10 -w 10 -I uesimtun0 8.8.8.8'
