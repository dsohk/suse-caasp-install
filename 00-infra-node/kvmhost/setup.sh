#! /bin/bash

# define current user
USR=suse

# add sudo privilege to the current user
if [ -d /etc/sudoers.d/$USR ]; then
  rm /etc/sudoers.d/$USR
fi
echo "$USR ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USR

zypper in -y openvswitch openvswitch-ovn-central openvswitch-ovn-host openvswitch-ovn-vtep
zypper in -y qemu-kvm
zypper in -y python2-cliff python3-cliff
zypper in -y python2-pyzmq python3-pyzmq
zypper in -y python2-virtualbmc


