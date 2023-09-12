#!/bin/bash

# Define the namespace and service account name
NAMESPACE="kube-system"
SERVICE_ACCOUNT_NAME="developer"

# Create the ServiceAccount
kubectl -n $NAMESPACE create serviceaccount $SERVICE_ACCOUNT_NAME

# Create the Secret
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: $SERVICE_ACCOUNT_NAME
  namespace: $NAMESPACE
  annotations:
    kubernetes.io/service-account.name: $SERVICE_ACCOUNT_NAME
type: kubernetes.io/service-account-token
EOF

echo "ServiceAccount and Secret for '$SERVICE_ACCOUNT_NAME' created in namespace '$NAMESPACE'."

