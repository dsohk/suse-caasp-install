#! /bin/bash -ex

# helm repo add jfrog https://charts.jfrog.io
# helm repo update

export NFS_IP=freenas.suse.lab

helm install --name artifactory \
  --namespace jfrog \
  --set artifactory.resources.requests.cpu="2" \
  --set artifactory.resources.limits.cpu="2" \
  --set artifactory.resources.requests.memory="4Gi" \
  --set artifactory.resources.limits.memory="4Gi" \
  --set artifactory.javaOpts.xms="4g" \
  --set artifactory.javaOpts.xmx="4g" \
  --set nginx.resources.requests.cpu="250m" \
  --set nginx.resources.limits.cpu="250m" \
  --set nginx.resources.requests.memory="500Mi" \
  --set nginx.resources.limits.memory="500Mi" \
  --set nginx.livenessProbe.initialDelaySeconds="60" \
  --set nginx.livenessProbe.periodSeconds="15" \
  --set nginx.livenessProbe.timeoutSeconds="60" \
  --set nginx.readinessProbe.initialDelaySeconds="60" \
  --set nginx.readinessProbe.periodSeconds="15" \
  --set nginx.readinessProbe.timeoutSeconds="60" \
  --set artifactory.image.repository=docker.bintray.io/jfrog/artifactory-oss \
  --set artifactory.persistence.type=nfs \
  --set artifactory.persistence.nfs.ip=${NFS_IP} \
  jfrog/artifactory


