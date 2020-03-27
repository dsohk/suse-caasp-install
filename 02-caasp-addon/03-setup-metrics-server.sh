#!/bin/bash

git clone https://github.com/kubernetes-sigs/metrics-server
cd metrics-server
kubectl create -f deploy/kubernetes
cd ..
rm -rf metrics-server

# Workaround on issue: https://github.com/kubernetes-sigs/metrics-server/issues/290
# edit metric-server deployment to add the flags
# args:
# - --kubelet-insecure-tls
# - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
kubectl edit -n kube-system deploy metrics-server
