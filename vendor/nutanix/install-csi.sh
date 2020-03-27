#! /bin/bash -ex

# pre-requisite
# install open-iscsi on all worker nodes
# zypper in open-iscsi

# download the CSI driver
wget http://download.nutanix.com/csi/v1.1.0/csi-v1.1.0.tar.gz
tar xvf csi-v1.1.0.tar.gz
rm -f csi-v1.1.0.tar.gz

cd CSI-v1.1.0

# create service account for Nutanix CSI
kubectl create -f ntnx-csi-rbac.yaml

# deploy statefulset and daemonset
kubectl create -f ntnx-csi-node.yaml
kubectl create -f ntnx-csi-provisioner.yaml

# create CSI driver object
kubectl apply -f csi-driver.yaml

# create secret
export YML=/tmp/ntnx-secret.yml
export PRISM_SECRETKEY=`echo -n 'prism-ip:port:admin:pass' | base64`
cat > ${YML} << EOF
apiVersion: v1
kind: Secret
metadata:
  name: ntnx-secret
  namespace: kube-system
data:
  # base64 encoded prism-ip:prism-port:admin:password. 
  # E.g.: echo -n "10.6.47.155:9440:admin:mypassword" | base64
  key: ${PRISM_SECRETKEY} 
EOF
kubectl apply -f ${YML}
rm ${YML}

# create storage class
export YML=/tmp/ntnx-sc.yml
export DATASERVICE_IP=192.168.0.10
export DATASERVICE_PORT=3260
cat > ${YML} << EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: acs-abs
  namespace: kube-system  
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: com.nutanix.csi
parameters:
    csi.storage.k8s.io/provisioner-secret-name: ntnx-secret
    csi.storage.k8s.io/provisioner-secret-namespace: kube-system
    csi.storage.k8s.io/node-publish-secret-name: ntnx-secret
    csi.storage.k8s.io/node-publish-secret-namespace: kube-system
    csi.storage.k8s.io/controller-expand-secret-name: ntnx-secret
    csi.storage.k8s.io/controller-expand-secret-namespace: kube-system
    csi.storage.k8s.io/fstype: ext4
    dataServiceEndPoint: ${DATASERVICE_IP}:${DATASERVICE_PORT}
    storageContainer: default-container-30293
    storageType: NutanixVolumes
allowVolumeExpansion: true
reclaimPolicy: Delete
EOF
kubectl apply -f ${YML}
rm ${YML}


