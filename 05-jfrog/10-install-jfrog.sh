#! /bin/bash -ex

helm repo add jfrog https://charts.jfrog.io

export NFS_IP=freenas.suse.lab

helm install --name artifactory \
  --namespace jfrog \
  --set artifactory.resources.requests.cpu="500m" \
  --set artifactory.resources.limits.cpu="2" \
  --set artifactory.resources.requests.memory="1Gi" \
  --set artifactory.resources.limits.memory="4Gi" \
  --set artifactory.javaOpts.xms="1g" \
  --set artifactory.javaOpts.xmx="4g" \
  --set nginx.resources.requests.cpu="100m" \
  --set nginx.resources.limits.cpu="250m" \
  --set nginx.resources.requests.memory="250Mi" \
  --set nginx.resources.limits.memory="500Mi" \
  --set artifactory.image.repository=docker.bintray.io/jfrog/artifactory-oss \
  --set artifactory.persistence.type=nfs \
  --set artifactory.persistence.nfs.ip=${NFS_IP} \
  jfrog/artifactory

