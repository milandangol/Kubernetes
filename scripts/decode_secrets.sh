
#!/bin/bash

# Get user input for the secret name and namespace
read -p "Enter the name of the secret: " secret_name
read -p "Enter the namespace where the secret is located: " namespace
read -p "Enter the key you want to decode from the secret: " key

# Use kubectl to retrieve the secret and decode the specified key's value
secret_value=$(kubectl get secret "$secret_name" -n "$namespace" -o jsonpath="{.data.$key}" | base64 -d)

if [ -n "$secret_value" ]; then
  echo "Decoded value of '$key' from '$secret_name' in namespace '$namespace':"
  echo "$secret_value"
else
  echo "Secret '$secret_name' not found in namespace '$namespace' or the specified key '$key' does not exist."
fi

