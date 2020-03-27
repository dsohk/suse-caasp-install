#!/bin/bash

YML=/tmp/nginx-ingress.yml
EXTIP=192.168.0.35  # use the first worker node as external IP (no fault tolerance, just for demo)

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
    externalIPs:
      - ${EXTIP}
EOF
cat ${YML}

# helm install --name nginx-ingress suse/nginx-ingress --values ${YML}

rm ${YML}

