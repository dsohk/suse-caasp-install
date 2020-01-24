#!/bin/bash

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
    externalIPs:
EOF
for NUM in $(seq 35 39 ); do
    printf "      - 192.168.0.${NUM}\n" >> ${YML}
done

helm install --name nginx-ingress suse/nginx-ingress --values ${YML}

rm ${YML}

