#!/bin/bash -eu

cd $(dirname $0)

kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

c1=$(kubectl get pods -A | grep -c "Running") || true
c2=$(kubectl get pods -A | grep -c "Pending") || true
while [ $c1 -ne 9 ] || [ $c2 -ne 0 ]
do
  sleep 1
  echo "[i] waiting multus running"
  c1=$(kubectl get pods -A | grep -c "Running") || true
  c2=$(kubectl get pods -A | grep -c "Pending") || true
done
sleep 3
echo "[+] multus running done"
