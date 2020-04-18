#! /bin/bash -ex

helm install --name prometheus stable/prometheus-operator --namespace monitoring
