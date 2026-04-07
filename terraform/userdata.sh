#!/bin/bash

apt update -y

# install docker
apt install docker.io -y
systemctl enable docker
systemctl start docker

# install kubernetes k3s
curl -sfL https://get.k3s.io | sh -

# wait for k3s
sleep 60

# allow ubuntu user to use kubectl
mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config