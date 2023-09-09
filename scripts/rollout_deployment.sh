#!/bin/bash

# Function to deploy a new version
deploy_new_version() {
  local deployment_name="$1"
  local new_image_tag="$2"
  
  kubectl set image deployment/"$deployment_name" "$deployment_name"="$new_image_tag" --record
  echo "Deployment '$deployment_name' updated to use image: $new_image_tag"
}

# Function to list available revisions for a deployment
list_revisions() {
  local deployment_name="$1"
  
  kubectl rollout history deployment/"$deployment_name"
}

# Function to perform a rollback
rollback() {
  local deployment_name="$1"
  local revision="$2"

  kubectl rollout undo deployment/"$deployment_name" --to-revision="$revision"
  echo "Rolled back deployment '$deployment_name' to revision $revision"
}

# Main menu
while true; do
  echo "Choose an option:"
  echo "1. List available revisions for a deployment"
  echo "2. Deploy new version"
  echo "3. Rollback"
  echo "4. Exit"
  read -p "Enter your choice (1/2/3/4): " choice

  case $choice in
    1)
      read -p "Enter deployment name: " deployment_name
      list_revisions "$deployment_name"
      ;;
    2)
      read -p "Enter deployment name: " deployment_name
      read -p "Enter new image tag: " new_image_tag
      deploy_new_version "$deployment_name" "$new_image_tag"
      ;;
    3)
      read -p "Enter deployment name: " deployment_name
      read -p "Enter revision to rollback to (e.g., 3): " revision
      rollback "$deployment_name" "$revision"
      ;;
    4)
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter 1, 2, 3, or 4."
      ;;
  esac
done

