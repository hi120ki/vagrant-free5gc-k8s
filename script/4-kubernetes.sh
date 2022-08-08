#!/bin/bash -eu

cd $(dirname $0)

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 192.168.56.202

mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

for i in {20..1}; do
  echo "[i] waiting kubeadm init $i"
  sleep 1
done

c1=$(kubectl get pods -A | grep -c "Running")
c2=$(kubectl get pods -A | grep -c "Pending")
while [ $c1 -ne 5 ] || [ $c2 -ne 2 ]
do
  sleep 1
  echo "[i] waiting coredns pending"
  c1=$(kubectl get pods -A | grep -c "Running")
  c2=$(kubectl get pods -A | grep -c "Pending")
done
sleep 3
echo "[+] coredns pending done"

sudo mkdir -p /opt/bin
sudo wget -q https://github.com/flannel-io/flannel/releases/download/v0.18.1/flanneld-amd64 -O /opt/bin/flanneld
sudo chmod +x /opt/bin/flanneld
kubectl apply -f /vagrant/conf/kube-flannel-0.18.1.yml

kubectl taint node --all node-role.kubernetes.io/control-plane:NoSchedule-

for i in {10..1}; do
  echo "[i] waiting taint nodes $i"
  sleep 1
done

c1=$(kubectl get pods -A | grep -c "Running")
c2=$(kubectl get pods -A | grep -c "Pending")
while [ $c1 -ne 8 ] || [ $c2 -ne 0 ]
do
  sleep 1
  echo "[i] waiting flannel running"
  c1=$(kubectl get pods -A | grep -c "Running")
  c2=$(kubectl get pods -A | grep -c "Pending")
done
sleep 3
echo "[+] flannel running done"

kubectl taint nodes --all node-role.kubernetes.io/master-

for i in {10..1}; do
  echo "[i] waiting taint nodes $i"
  sleep 1
done

kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/v3.9/deployments/multus-daemonset-thick-plugin.yml

c1=$(kubectl get pods -A | grep -c "Running")
c2=$(kubectl get pods -A | grep -c "Pending")
while [ $c1 -ne 9 ] || [ $c2 -ne 0 ]
do
  sleep 1
  echo "[i] waiting multus running"
  c1=$(kubectl get pods -A | grep -c "Running")
  c2=$(kubectl get pods -A | grep -c "Pending")
done
sleep 3
echo "[+] multus running done"

echo "[+] kubernetes init finished"
