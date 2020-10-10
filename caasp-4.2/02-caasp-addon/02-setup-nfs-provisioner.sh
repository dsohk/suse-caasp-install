#! /bin/bash -ex

# nfs-server
# > cat /etc/exports
# /mnt/pool1 *(rw,no_root_squash,sync)

NFSHOST=freenas.suse.lab
NFSPATH=/mnt/pool1

# Setup NFS-Client Provisioner as default Storage Class
helm install --name nfs --namespace kube-system \
  --set storageClass.defaultClass=true \
  --set nfs.server=$NFSHOST \
  --set nfs.path=$NFSPATH \
  stable/nfs-client-provisioner \
  --wait

# list if storage class exists now
kubectl get sc

# test if storage class is working
kubectl apply -f nfs-provisioner-test.yaml

# the server should have volume provisioned by nfs-provisioner and attached to a pod
kubectl get rc server

# undone the test when it's okay
kubectl delete -f nfs-provisioner-test.yaml

# mark all pv finalizers as null to speed up removal
kubectl get pv | tail -n+2 | awk '{print $1}' | xargs -I{} kubectl patch pv {} -p '{"metadata":{"finalizers": null}}'

