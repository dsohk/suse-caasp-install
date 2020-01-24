#!/bin/bash -ex

DOMAIN=suse.lab
YML=/tmp/grafana-config-values.yaml

git clone https://github.com/suse/caasp-monitoring

cat > ${YML} << EOF
# Configure admin password
adminPassword: linux

# Ingress configuration
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  hosts:
    - grafana.${DOMAIN}
  tls:
    - hosts:
      - grafana.${DOMAIN}
      secretName: monitoring-tls

# Configure persistent storage
persistence:
  enabled: true
  accessModes:
    - ReadWriteOnce
  ## Create a PersistentVolumeClaim of 10Gi
  size: 10Gi
  ## Use an existing PersistentVolumeClaim (my-pvc)
  #existingClaim: grafana

# Enable sidecar for provisioning
sidecar:
  datasources:
    enabled: true
    label: grafana_datasource
  dashboards:
    enabled: true
    label: grafana_dashboard
EOF

# setup grafana data source
kubectl create -f grafana-datasources.yaml

# deploy grafana on kubernetes
helm install --name grafana suse/grafana \
  --namespace monitoring \
  --values ${YML}

# add sample dashboard for CaaSP
kubectl apply -f caasp-monitoring/grafana-dashboards-caasp-cluster.yaml



printf "\n You need to add the following to your /etc/hosts file:\n"
cat << EOF 

Grafana:
url: https://grafana.${DOMAIN}
user: admin
pass: $(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)

Prometheus:
url: https://prometheus.${DOMAIN}
user: admin
pass: linux

AlertManager:
url: https://prometheus-alertmanager.${DOMAIN}
user: admin
pass: linux

EOF
