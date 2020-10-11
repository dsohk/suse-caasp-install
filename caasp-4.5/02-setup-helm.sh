#! /bin/bash -ex

# setup helm 2

sudo zypper in -y helm
TILLER_VER=2.16.9
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --tiller-image registry.suse.com/caasp/v4.5/helm-tiller:$TILLER_VER --service-account tiller

# add suse helm repo
helm repo add suse https://kubernetes-charts.suse.com/
helm repo list
helm repo update
helm search suse

# setup helm 3

sudo zypper in -y helm3
helm3 repo add suse https://kubernetes-charts.suse.com/
helm3 repo list
helm3 search repo suse


