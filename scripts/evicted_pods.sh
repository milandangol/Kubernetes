#!/bin/bash

# Get user input for the namespace
read -p "Enter the namespace where you want to delete evicted pods: " namespace

# Get a list of pod names in the "Evicted" state in the specified namespace
evicted_pods=$(kubectl get pod -n "$namespace" | grep "Evicted" | awk '{print $1}')

# Check if there are any evicted pods to delete
if [ -z "$evicted_pods" ]; then
  echo "No evicted pods found in the '$namespace' namespace."
else
  # Iterate through the list of evicted pod names and delete them
  for pod in $evicted_pods; do
    echo "Deleting evicted pod: $pod"
    kubectl delete pod "$pod" -n "$namespace"
  done
fi

