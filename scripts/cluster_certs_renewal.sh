#!/bin/sh

echo "Starting certificate renewal"

# Create a timestamp for backup directory
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="/root/kube-backup/$TIMESTAMP"

echo "Creating backup in $BACKUP_DIR"

# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Copy configuration files and PKI certificates to the backup directory
cp -p /etc/kubernetes/*.conf "$BACKUP_DIR"
cp -pr /etc/kubernetes/pki "$BACKUP_DIR"

echo "Backup complete"

echo "Renewing certificates"

# Renew all certificates using kubeadm
kubeadm alpha certs renew all

echo "Renewal complete"

echo "Restarting pods"

# Move manifest files to a temporary directory
mkdir -p /tmp/kubernetes-manifests
mv /etc/kubernetes/manifests/etcd.yaml /tmp/kubernetes-manifests/
mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kubernetes-manifests/
mv /etc/kubernetes/manifests/kube-controller-manager.yaml /tmp/kubernetes-manifests/
mv /etc/kubernetes/manifests/kube-scheduler.yaml /tmp/kubernetes-manifests/

echo "Waiting for pods to be stopped"
echo "Service will be paused for 1 minute to prune unused pods"
sleep 1m # Wait for 1 minute to allow unused pods to be pruned

echo "Service Resumed"

# Move manifest files back to the original directory
mv /tmp/kubernetes-manifests/etcd.yaml /etc/kubernetes/manifests/
mv /tmp/kubernetes-manifests/kube-apiserver.yaml /etc/kubernetes/manifests/
mv /tmp/kubernetes-manifests/kube-controller-manager.yaml /etc/kubernetes/manifests/
mv /tmp/kubernetes-manifests/kube-scheduler.yaml /etc/kubernetes/manifests/

echo "Certificate renewal complete"

