#! /bin/bash

# apply cert manager crds
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.crds.yaml

# create ns for cert manager
kubectl create namespace cert-manager

# add jetstack helm repo and then update
helm repo add jetstack https://charts.jetstack.io
helm repo update

# install
helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.14.1 \
  jetstack/cert-manager

# verify
kubectl get pods --namespace cert-manager

# test

cat <<EOF > test-resources.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - example.com
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF

kubectl apply -f test-resources.yaml

kubectl describe certificate -n cert-manager-test

kubectl delete -f test-resources.yaml



# setup selfsigned clusterIssuser

cat <<EOF > selfsigned-clusterissuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: selfsigning-issuer
spec:
  selfSigned: {}
EOF

kubectl apply -f selfsigned-clusterissuer.yaml

# check readiness
kubectl describe clusterissuer.cert-manager.io/selfsigning-issuer

# create a CA cert
cat <<EOF > self-signed-caasp-root-ca.yaml
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: suse-caasp-crt
spec:
  secretName: suse-caasp-cert
  commonName: "SUSE CaaSP root CA"
  isCA: true
  issuerRef:
    name: selfsigning-issuer
    kind: ClusterIssuer
EOF

kubectl apply -f self-signed-caasp-root-ca.yaml

# check root CA cert issued
kubectl describe certificate.cert-manager.io/suse-caasp-crt


