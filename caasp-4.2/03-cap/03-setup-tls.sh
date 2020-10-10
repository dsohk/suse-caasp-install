#! /bin/bash
# generate SUSE CAP root CA and server key for ingress

export DOMAIN=cap.suse.lab

# generate SUSE CAP root CA key
openssl genrsa -out susecap-ca.key 4096
# generate SUSE CAP root cert
openssl req -x509 -new -nodes -key susecap-ca.key \
  -subj "/C=HK/ST=Hong Kong/O=SUSE/OU=Demo/CN=${DOMAIN}/emailAddress=admin@${DOMAIN}" \
  -sha256 -days 3650 -out susecap-ca.crt


# generate SUSE CAP server CSR

cat > susecap-openssl.conf << EOF
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
OU = Demo
CN = ${DOMAIN}
emailAddress = admin@${DOMAIN}
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = *.${DOMAIN}
DNS.3 = uaa.${DOMAIN}
DNS.4 = *.uaa.${DOMAIN}
EOF


openssl genrsa -out susecap-server.key 2048

openssl req -new -sha256 \
    -key susecap-server.key \
    -config susecap-openssl.conf \
    -out susecap-server.csr


# Verify the CSR's content
openssl req -in susecap-server.csr -noout -text


# Generate the certificate using the susecap-server csr and key along with the CA Root key
openssl x509 -req -in susecap-server.csr \
  -CA susecap-ca.crt -CAkey susecap-ca.key \
  -CAcreateserial -out susecap-server.crt -days 3650 -sha256


# Vierfy the server certificate content
openssl x509 -in susecap-server.crt -text -noout

exit

