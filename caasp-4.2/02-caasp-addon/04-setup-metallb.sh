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
    - 192.168.0.90-192.168.0.99
EOF

#kubectl apply -f ${YML}
helm install --namespace metallb-system --name metallb stable/metallb -f ${YML}
rm ${YML}
