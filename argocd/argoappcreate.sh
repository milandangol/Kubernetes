#!/bin/bash

# author: Milan Dangol
# email: milan.dangol57@gmail.com 
#Prompt the user for the Bitbucket folder_name
read -p "Enter the root Bitbucket folder name (e.g., <parent dir>): " bitbucket_folder

# Define the temporary directory for cloning repositories
temp_dir=$(mktemp -d)

# Ensure the temporary directory exists

branch_name=$(echo "$bitbucket_folder" | cut -d'-' -f2 )

# Create a temporary directory for manifest files
manifest_dir=/tmp/argomanifest
mkdir $manifest_dir
# Clone the repository from Bitbucket using SSH
bitbucket_url="git@bitbucket.org:<reponame>"
git clone -b $branch_name "$bitbucket_url" "$temp_dir"

# Change to the temporary directory
cd "$temp_dir"
pattern="^([^-]+)-(.+)$"
# Check if the specified folder exists
if [ -d "$bitbucket_folder" ]; then
    # Loop through the directories and generate manifests
    for dir in "$bitbucket_folder"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            if [[ $dir_name =~ $pattern ]]; then
                new_text="${BASH_REMATCH[1]}-$branch_name-${BASH_REMATCH[2]}"
                echo "$new_text"
            else
                echo "Input does not match the pattern."
            fi
            # Define the template for the manifest
            template="apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $new_text
  namespace: argocd
spec:
  destination:
    name: ''
    namespace: $bitbucket_folder  
    server: 'https://kubernetes.default.svc'
  source:
    path: "$bitbucket_folder/$dir_name"
    repoURL: '$bitbucket_url'
    targetRevision: $branch_name
  sources: []
  project: finpos
  syncPolicy:
    automated:
      prune: false
      selfHeal: false"

            # Save the template to a file in the manifest directory
            echo "$template" > "$manifest_dir/${dir_name}_manifest.yaml"

            echo "Manifest for $dir_name has been generated in $manifest_dir/${dir_name}_manifest.yaml"
        fi
    done
else
    echo "Folder '$bitbucket_folder' not found in Bitbucket repository."
fi

# Cleanup: Remove only the temporary clone directory
rm -rf "$temp_dir"
