#! /bin/bash -ex

## CONFIGURATION ##
SKUBA_CLUSTERNAME=caasp-cluster1


## OPERATION ##

# generate ssh key for skuba
rm ~/.ssh/skuba.*
ssh-keygen -t rsa -P '' -f ~/.ssh/skuba.pem

# copy to all master nodes, worker nodes
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-m1
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-m2
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-m3
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-w1
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-w2
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-w3
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-w4
ssh-copy-id -i ~/.ssh/skuba.pem.pub caasp-w5

# ensure all k8s nodes has passwordless sudo
ssh caasp-m1 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-m2 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-m3 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-w1 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-w2 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-w3 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-w4 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
ssh caasp-w5 -l root 'echo "suse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

# enable passwordless ssh in this session
eval "$(ssh-agent)"
ssh-add ~/.ssh/skuba.pem

# ensure all worker node has /etc/sysctl.conf set ipv4 forward = 1
# see https://bugzilla.suse.com/show_bug.cgi?id=1150212

# using skuba to deploy caasp into all nodes
cd $HOME
time skuba cluster init --control-plane caasp-lb.suse.lab $SKUBA_CLUSTERNAME
cd $SKUBA_CLUSTERNAME/
time skuba node bootstrap -v=1 --user suse --sudo --target caasp-m1.suse.lab caasp-m1
time skuba node join --role master -v=1 --user suse --sudo --target caasp-m2.suse.lab caasp-m2
time skuba node join --role master -v=1 --user suse --sudo --target caasp-m3.suse.lab caasp-m3
time skuba node join --role worker -v=1 --user suse --sudo --target caasp-w1.suse.lab caasp-w1
time skuba node join --role worker -v=1 --user suse --sudo --target caasp-w2.suse.lab caasp-w2
time skuba node join --role worker -v=1 --user suse --sudo --target caasp-w3.suse.lab caasp-w3
time skuba node join --role worker -v=1 --user suse --sudo --target caasp-w4.suse.lab caasp-w4
time skuba node join --role worker -v=1 --user suse --sudo --target caasp-w5.suse.lab caasp-w5
skuba cluster status

# setup kubeconfig for kubectl
ln -s ~/$SKUBA_CLUSTERNAME/admin.conf ~/.kube/config

kubectl label node caasp-w1 node-role.kubernetes.io/worker=
kubectl label node caasp-w2 node-role.kubernetes.io/worker=
kubectl label node caasp-w3 node-role.kubernetes.io/worker=
kubectl label node caasp-w4 node-role.kubernetes.io/worker=
kubectl label node caasp-w5 node-role.kubernetes.io/worker=

