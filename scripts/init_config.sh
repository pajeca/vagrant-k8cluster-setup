#!/usr/bin/bash
set -euxo

#disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

## Install CRI-O
sudo apt update
sudo apt install -y curl jq
curl https://raw.githubusercontent.com/cri-o/cri-o/main/scripts/get | sudo bash

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio
