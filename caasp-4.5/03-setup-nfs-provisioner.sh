#! /bin/bash -ex

NFSHOST=nfs.suse.lab
NFSPATH=/data

# Setup NFS-Client Provisioner as default Storage Class
helm install --name nfs --namespace kube-system \
  --set storageClass.defaultClass=true \
  --set nfs.server=$NFSHOST \
  --set nfs.path=$NFSPATH \
  stable/nfs-client-provisioner \
  --wait

# list if storage class exists now
kubectl get sc
