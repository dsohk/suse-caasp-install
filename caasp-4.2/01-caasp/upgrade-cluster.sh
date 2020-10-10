#! /bin/bash

SKUBA_CLUSTERNAME=caasp-cluster1

# fetch latest rpm
sudo zypper ref
sudo zypper up

# check if cluster need upgrade
skuba cluster upgrade plan
skuba addon upgrade plan


# using skuba to deploy caasp into all nodes
cd $HOME
cd $SKUBA_CLUSTERNAME/
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-m1
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-m2
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-m3
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-w1
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-w2
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-w3
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-w4
time skuba node upgrade apply -v=5 --sudo --user suse --target caasp-w5

skuba cluster status
