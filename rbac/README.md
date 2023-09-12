# RBAC (Role-Based Access Control) Configuration

This directory contains RBAC configuration files for managing access control in your application or Kubernetes cluster.

## Files

1. **create_developer_serviceaccount.sh**

   - Description: Shell script to create a service account for developers.
   - Usage: Execute this script to create the developer service account.

2. **developer-rolebind.yaml**

   - Description: YAML file defining a RoleBinding for developers.
   - Usage: Apply this RoleBinding to grant permissions to the developer service account.

3. **developer-role.yaml**

   - Description: YAML file defining a Role for developers.
   - Usage: Apply this Role to specify the permissions developers should have.

4. **developer-clusterrole.yaml**

   - Description: YAML file defining a ClusterRole for developers.
   - Usage: Apply this ClusterRole to specify global permissions for developers.

5. **developer-clusterrolebind.yaml**

   - Description: YAML file defining a ClusterRoleBinding for developers.
   - Usage: Apply this ClusterRoleBinding to bind the ClusterRole to users or service accounts.

## Usage

Follow these steps to set up RBAC for your application or Kubernetes cluster:

1. Execute the `create_developer_serviceaccount.sh` script to create the developer service account.

2. Apply the RBAC configurations using the respective YAML files:
   - Apply `developer-rolebind.yaml` to bind the Role to the service account.
   - Apply `developer-role.yaml` to define the Role's permissions.
   - Apply `developer-clusterrole.yaml` to define ClusterRole permissions.
   - Apply `developer-clusterrolebind.yaml` to bind ClusterRole permissions to users or service accounts.

## Blog

You can also check out my blog for step by step guide on  [hasnode](https://milaan.hashnode.dev/).

- Customize the Role, ClusterRole, and RoleBinding configurations to suit your specific access control requirements.

Feel free to reach out if you have any questions or need further assistance with RBAC configuration.

