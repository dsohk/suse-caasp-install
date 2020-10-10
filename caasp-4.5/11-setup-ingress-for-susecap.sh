#! /bin/bash

#!/bin/bash -ex

YML=/tmp/nginx-ingress-susecap.yml

cat > ${YML} << EOF
tcp:
  2222: "kubecf/scheduler:2222"
  20000: "kubecf/tcp-router:20000"
  20001: "kubecf/tcp-router:20001"
  20002: "kubecf/tcp-router:20002"
  20003: "kubecf/tcp-router:20003"
  20004: "kubecf/tcp-router:20004"
  20005: "kubecf/tcp-router:20005"
  20006: "kubecf/tcp-router:20006"
  20007: "kubecf/tcp-router:20007"
  20008: "kubecf/tcp-router:20008"
EOF

helm upgrade nginx-ingress stable/nginx-ingress --reuse-values -f ${YML}

rm ${YML}



