#!/usr/bin/bash
set -euxo

#disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Install Latest version of CRI-O, which will always be the same version as current version of kubeadm
sudo apt update
sudo apt install -y curl jq
curl https://raw.githubusercontent.com/cri-o/cri-o/main/scripts/get | sudo bash

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio

# Configure CRI-O Mods
sudo tee /etc/modules-load.d/crio.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure IPtables
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# install kubelet kubeadm kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet --now
