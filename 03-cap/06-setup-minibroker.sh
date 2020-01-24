#! /bin/bash -ex

CF_API=https://api.cap.ptpoc.lab
CF_USER=admin
CF_PWD=Abc123.lab

helm install suse/minibroker --namespace minibroker \
  --name minibroker  \
  --set "defaultNamespace=minibroker" --wait

helm status minibroker

# wait until minibroker done

cf api --skip-ssl-validation $CF_API
cf login -u $CF_USER -p "$(CF_PWD)"
cf create-org demo
cf create-space dev -o demo
cf create-space prod -o demo
sleep 30
cf target -o demo -s dev
cf create-service-broker minibroker username password http://minibroker-minibroker.minibroker.svc.cluster.local
cf service-brokers
cf service-access -b minibroker
cf enable-service-access redis
cf enable-service-access mysql
cf enable-service-access postgresql
cf enable-service-access mariadb
cf enable-service-access mongodb
cf marketplace
