#! /bin/bash


helm3 install kubecf suse/kubecf \
  --namespace kubecf \
  --values kubecf-config-values.yaml \
  --version 2.2.3


