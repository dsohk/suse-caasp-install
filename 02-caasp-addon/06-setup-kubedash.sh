#!/bin/bash

# Deploy Kubernetes Dashboard for K8s 1.16+ (CaaSP 4.0.3)
# Doc:    https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# Github: https://github.com/kubernetes/dashboard/releases



# Step one: clean up old stuff in the kubernetes-dashboard namespace
kubectl delete ns kubernetes-dashboard --ignore-not-found=true

# Step two: deploy kubernetes-dashboard 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc2/aio/deploy/recommended.yaml

# Step three: check if kubernetes dashboard is ready
kubectl get all -n kubernetes-dashboard

# wait for 1 min until provisioning is completed.
sleep 60

# setup sample user
# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

cat >/tmp/dashboard-admin.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF
kubectl apply -f /tmp/dashboard-admin.yaml

cat >/tmp/admin-user-crb.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
EOF
kubectl apply -f /tmp/admin-user-crb.yaml
rm -f /tmp/dashboard-admin.yaml /tmp/admin-user-crb.yaml 2>/dev/null


# extract token and save to kubeconfig
ST=$(kubectl -n kubernetes-dashboard get serviceaccounts admin-user -o jsonpath="{.secrets[0].name}")
SECRET=$(kubectl -n kubernetes-dashboard get secret ${ST} -o jsonpath="{.data.token}"|base64 -d)
echo "    token: $SECRET" >> ~/.kube/config

# Access dashboard
# kubectl proxy
# visit: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


