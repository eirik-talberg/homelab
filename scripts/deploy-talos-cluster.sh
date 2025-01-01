#! /bin/bash

set -e

ENVIRONMENT=$1
CLUSTER_ID=$2

USAGE="Usage: ./deploy-talos-cluster <env> <cluster_id>"

if [ $ENVIRONMENT == "" ]; then
    echo $USAGE
    echo "Missing env"
    exit 1
elif [ $CLUSTER_ID == "" ]; then
    echo $USAGE
    echo "Missing cluster id"
    exit 1
fi

CLUSTER_NAME=tls-$ENVIRONMENT-$CLUSTER_ID
TF_WORKSPACE=$ENVIRONMENT-$CLUSTER_ID
VARS_DIR=$(pwd)/environments/$ENVIRONMENT/k8s/$CLUSTER_NAME/infra

WORKSPACE_MODULE=$(pwd)/infra/hcp/modules/workspace
CLUSTER_MODULE=$(pwd)/infra/k8s/talos
K8S_MODULE=$(pwd)/tfmodules/k8s/bootstrap 

terraform -chdir=$WORKSPACE_MODULE init
terraform -chdir=$WORKSPACE_MODULE plan -var-file=$VARS_DIR/workspace_cluster.tfvars -out=$CLUSTER_NAME-workspace_cluster.tfplan
terraform -chdir=$WORKSPACE_MODULE apply $CLUSTER_NAME-workspace_cluster.tfplan

export TF_WORKSPACE="$TF_WORKSPACE-cluster"
terraform -chdir=$CLUSTER_MODULE  init
terraform -chdir=$CLUSTER_MODULE  plan -var-file=$VARS_DIR/cluster.tfvars -out=$CLUSTER_NAME-cluster.tfplan
terraform -chdir=$CLUSTER_MODULE  apply $CLUSTER_NAME-cluster.tfplan

terraform -chdir=$WORKSPACE_MODULE init
terraform -chdir=$WORKSPACE_MODULE plan -var-file=$VARS_DIR/workspace_bootstrap.tfvars -out=$CLUSTER_NAME-workspace_bootstrap.tfplan
terraform -chdir=$WORKSPACE_MODULE apply $CLUSTER_NAME-workspace_bootstrap.tfplan


export TF_WORKSPACE="$TF_WORKSPACE-bootstrap"
terraform -chdir=$K8S_MODULE init
terraform -chdir=$K8S_MODULE  plan -var-file=$VARS_DIR/k8s_bootstrap.tfvars -out=$CLUSTER_NAME-k8s_bootstrap.tfplan
terraform -chdir=$K8S_MODULE  apply $CLUSTER_NAME-k8s_bootstrap.tfplan

pdm run ansible-playbook ansible/talos-k8s.yaml --extra-vars "kube_config=$HOME/.kube/$CLUSTER_NAME target_revision=feat/talos_cluster_infra" 