#! /bin/bash -x

# lock down helm chart version
# See: https://documentation.suse.com/suse-cap/1.5.2/html/cap-guides/cha-cap-depl-notes.html#id-1.3.4.3.10
export HELM_SCF_VER=2.20.3
export HELM_STRATOS_VER=2.7.0
export HELM_METRICS_VER=1.1.2

# https://documentation.suse.com/suse-cap/1.5/html/cap-guides/cha-cap-ingress.html

helm install suse/uaa \
  --name susecf-uaa \
  --version $HELM_SCF_VER \
  --namespace uaa \
  --values scf-config-values.yaml

# wait until uaa is completed
watch -c 'kubectl get pod -n uaa'

# should return config text 
curl --insecure https://uaa.cap.suse.lab/.well-known/openid-configuration


