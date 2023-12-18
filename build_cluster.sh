#!/usr/bin/env bash

CLUSTER=$1
echo "Provisioning cluster: $CLUSTER"

cd ansible
echo "$CLUSTER: Creating infra"
ansible-playbook provision-k3s-cluster.yaml --extra-vars "cluster_name=$CLUSTER"

echo "$CLUSTER: Installing k3s"
ansible-playbook -i inventories/$CLUSTER/hosts.ini install-k3s.yaml

echo "$CLUSTER: Configuring Kubernetes (k3s)"
ansible-playbook -i inventories/$CLUSTER/hosts.ini configure-k8s.yaml
