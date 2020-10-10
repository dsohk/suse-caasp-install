#! /bin/bash

# SUSE CAP deployment requires helm3, not helm2. Let's set this up now.
sudo zypper in -y helm3
helm3 repo add suse https://kubernetes-charts.suse.com/
helm3 repo list
helm3 search repo suse

# Let's start deploy cf-operator now

kubectl create namespace cf-operator

helm3 install cf-operator suse/cf-operator \
  --namespace cf-operator \
  --set "global.operator.watchNamespace=kubecf" \
  --version 4.5.13+0.gd4738712


exit
