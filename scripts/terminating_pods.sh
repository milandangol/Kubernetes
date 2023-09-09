#!/bin/bash

# Display a short disclaimer
echo "WARNING: This script will forcefully delete a Kubernetes pod in a specified namespace. Only use for terminating pod."

# Get user input for pod name
read -p "Enter the name of the pod you want to delete: " POD_NAME

# Get user input for namespace
read -p "Enter the namespace of the pod: " NAMESPACE

# Confirmation prompt
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "Operation canceled."
  exit 1
fi

# Delete the pod forcefully
kubectl delete pod "$POD_NAME" --grace-period=0 --force --namespace "$NAMESPACE"

echo "Pod '$POD_NAME' in namespace '$NAMESPACE' has been forcefully deleted."

