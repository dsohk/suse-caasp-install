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
  extraArgs:
    v: 2
  service:
    type: LoadBalancer
EOF

helm install --name nginx-ingress --namespace nginx-ingress stable/nginx-ingress --values ${YML}

rm ${YML}

