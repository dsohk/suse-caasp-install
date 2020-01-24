#! /bin/bash -ex

# clean up uaa
kubectl delete statefulsets --all --namespace uaa
helm delete --purge susecf-uaa
kubectl delete namespace uaa

# clean up scf
kubectl delete statefulsets --all --namespace scf
helm delete --purge susecf-scf
kubectl delete namespace scf


