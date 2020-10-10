#! /bin/bash

kubectl create namespace stratos

helm3 install susecf-console suse/console \
--namespace stratos \
--values stratos-config-values.yaml


