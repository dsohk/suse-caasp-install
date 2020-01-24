#! /bin/bash -x

# https://documentation.suse.com/suse-cap/1.5/html/cap-guides/cha-cap-ingress.html

helm install suse/uaa \
  --name susecf-uaa \
  --namespace uaa \
  --values scf-config-values.yaml

# wait until uaa is completed
watch -c 'kubectl get pod -n uaa'

# should return config text 
curl --insecure https://uaa.open-cloud.net:2793/.well-known/openid-configuration


