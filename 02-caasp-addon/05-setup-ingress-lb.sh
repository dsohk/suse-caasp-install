#!/bin/bash -ex

YML=/tmp/nginx-ingress.yml

cat > ${YML} << EOF
# Enable the creation of pod security policy
podSecurityPolicy:
  enabled: true

# Create a specific service account
serviceAccount:
  create: true
  name: nginx-ingress

# Publish services on port HTTP/80
# Publish services on port HTTPS/443
controller:
  service:
    type: LoadBalancer
EOF

helm install --name nginx-ingress --namespace kube-system stable/nginx-ingress --values ${YML}

rm ${YML}

