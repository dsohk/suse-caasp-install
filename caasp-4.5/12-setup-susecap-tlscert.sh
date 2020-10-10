#! /bin/bash

export DOMAIN=cap.suse.lab

# We will be using self signed certificates for prometheus and grafana,
# we need to create that (the same certificate will be used for all three URLs)
printf "Creating self signed certificates for SUSE cloud application platform\n"
cat > /tmp/openssl.conf << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
default_md = sha256
default_bits = 4096
prompt=no

[req_distinguished_name]
C = HK
ST = Hong Kong
L = Hong Kong
O = SUSE
OU = cap
CN = ${DOMAIN}
emailAddress = admin@${DOMAIN}

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.${DOMAIN}
EOF

openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
  -keyout /tmp/susecap.key -out /tmp/susecap.crt \
  -config /tmp/openssl.conf -extensions 'v3_req'


# Please manually add the content of /tmp/susecap.key and /tmp/susecap.crt into kubecf-config-values.yaml file

exit
