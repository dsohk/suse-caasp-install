#! /bin/bash -ex

DOMAIN=cap.suse.lab

helm install suse/uaa \
  --name susecf-uaa \
  --namespace uaa \
  --values scf-config-values.yaml

# wait until uaa is completed

UAA_IP="$(kubectl get svc --namespace uaa uaa-uaa-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
# configure DNS for the domain
echo "${UAA_IP} *.uaa.${DOMAIN}"
echo "${UAA_IP} uaa.${DOMAIN}"

curl --insecure https://uaa.$DOMAIN:2793/.well-known/openid-configuration

SECRET=$(kubectl get pods --namespace uaa \
  -o jsonpath='{.items[?(.metadata.name=="uaa-0")].spec.containers[?(.name=="uaa")].env[?(.name=="INTERNAL_CA_CERT")].valueFrom.secretKeyRef.name}')

CA_CERT="$(kubectl get secret $SECRET --namespace uaa \
  -o jsonpath="{.data['internal-ca-cert']}" | base64 --decode -)"

helm install suse/cf \
  --name susecf-scf \
  --namespace scf \
  --values scf-config-values.yaml \
  --set "secrets.UAA_CA_CERT=${CA_CERT}"


GOROUTER_IP="$(kubectl get svc --namespace scf router-gorouter-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
DIEGOSSH_IP="$(kubectl get svc --namespace scf diego-ssh-ssh-proxy-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
TCPROUTER_IP="$(kubectl get svc --namespace scf tcp-router-tcp-router-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
# configure DNS for the domain
echo "${GOROUTER_IP} ${DOMAIN}"
echo "${GOROUTER_IP} *.${DOMAIN}"
echo "${DIEGOSSH_IP} ssh.${DOMAIN}"
echo "${TCPROUTER_IP} tcp.${DOMAIN}"

