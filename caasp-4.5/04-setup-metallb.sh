#!/bin/bash
YML=/tmp/metallb.yaml

echo "Setting up MetalLB..."

kubectl create namespace metallb-system

cat > ${YML} <<EOF
configInline:
  address-pools:
  - name: default
    protocol: layer2
    addresses:
    - 192.168.122.20-192.168.122.29
EOF

#kubectl apply -f ${YML}
helm install --namespace metallb-system --name metallb stable/metallb -f ${YML}
rm ${YML}
