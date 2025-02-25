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

CLUSTER_NAME=$ENVIRONMENT-tls-$CLUSTER_ID
TF_WORKSPACE=$ENVIRONMENT-$CLUSTER_ID
VARS_DIR=$(pwd)/environments/$ENVIRONMENT/k8s/$CLUSTER_NAME/infra

WORKSPACE_MODULE=$(pwd)/infra/hcp/modules/workspace
CLUSTER_MODULE=$(pwd)/infra/k8s/talos
K8S_MODULE=$(pwd)/tfmodules/k8s/bootstrap 

export TF_WORKSPACE="$TF_WORKSPACE-bootstrap"
terraform -chdir=$K8S_MODULE init
terraform -chdir=$K8S_MODULE  plan -var-file=$VARS_DIR/k8s_bootstrap.tfvars -out=$CLUSTER_NAME-k8s_bootstrap.tfplan
terraform -chdir=$K8S_MODULE  apply $CLUSTER_NAME-k8s_bootstrap.tfplan