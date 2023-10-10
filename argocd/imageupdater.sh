#!/bin/bash

# author: Milan Dangol
# email: milan.dangol57@gmail.global
# Version: 4
#-----------------
# How to run this ?
# chmod +x argocdscript
# ./argocdscript <deploy path > <bitbucket folder>
#./argocdscript ${WORKSPACE}/k8s/app.yaml <parent_dir>/<child_dir>
#--------------------
# Function to display an error message and exit
script_pid=$$
function die() {
    echo "Error: $1"
    kill -9 $script_pid  # Kill the script on error
    exit 1
}

# Check the number of arguments
if [ "$#" -ne 2 ]; then
    die "Usage: $0 <file_path> <bitbucket_folder> "
fi

# Assign the arguments to variables
file_path="$1"
bitbucket_folder="$2"

# Extract the branch name from the directory parameter
branch_name=$(echo "$bitbucket_folder" | cut -d'/' -f1 | cut -d'-' -f2-)

echo "Using branch $branch_name ...."

# Bitbucket SSH URL (replace with your repository's SSH URL)
bitbucket_ssh_url="git@bitbucket.org:<repositoryname>"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    die "The specified file does not exist."
fi

# Clone the Bitbucket repository to a temporary directory
temp_dir=$(mktemp -d)
git clone -b "$branch_name" "$bitbucket_ssh_url" "$temp_dir" || die "Failed to clone the Bitbucket repository."

# Change Directory
cd "$temp_dir"

# Check if the directory $temp_dir/$bitbucket_folder/ exists, and create it if not along with deploy.yaml
if [ ! -d "$temp_dir/$bitbucket_folder" ]; then
    mkdir -p "$temp_dir/$bitbucket_folder" || die "Failed to create directory $temp_dir/$bitbucket_folder."
    touch "$temp_dir/$bitbucket_folder/deploy.yaml" || die "Failed to create deploy.yaml file."
fi

# Copy the file to the destination folder
cp "$file_path" "$temp_dir/$bitbucket_folder/deploy.yaml" || die "Failed to copy the file to the Bitbucket repository folder."


# Copy the file to a specific filename (e.g., deploy.yaml) in the Bitbucket repository folder
cp "$file_path" "$temp_dir/$bitbucket_folder/deploy.yaml" || die "Failed to copy the file to the Bitbucket repository folder."

# Use the Jenkins build number as the image tag
jenkins_build_number="$BUILD_NUMBER"
if [ -z "$jenkins_build_number" ]; then
    die "Jenkins build number is not set. Make sure you're running this script in a Jenkins build environment."
fi

# Define the image prefix
image_prefix="<azure-container-registery>/"

# Combine the prefix, image name, and Jenkins build number to create the new image URL
new_image_url="${image_prefix}${bitbucket_folder}:${jenkins_build_number}"

# Modify the deployment file (deploy.yaml) to set the new image URL
deployment_file="$temp_dir/$bitbucket_folder/deploy.yaml"
if [ ! -f "$deployment_file" ]; then
    die "The deployment file $deployment_file does not exist."
fi

# Use sed to replace the image URL in the deployment file
sed -i "s|image:.*|image: $new_image_url|g" "$deployment_file" || die "Failed to update the image URL in $deployment_file."

# Commit the changes to Bitbucket
git add . --all
git commit -m "Updated Manifest file $jenkins_build_number" || die "Failed to commit changes."

# Push the changes to Bitbucket
git push origin "$branch_name" || die "Failed to push changes to Bitbucket."

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "File successfully pushed to Bitbucket with updated image tag on branch $branch_name."

exit 0