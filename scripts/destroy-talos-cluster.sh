#! /bin/bash

ENVIRONMENT=$1
CLUSTER_ID=$2

USAGE="Usage: ./deploy-talos-cluster <env> <cluster_id>"

if [[ $ENVIRONMENT == "" ]]; then
    echo $USAGE
    echo "Missing env"
    exit 1
elif [[ $CLUSTER_ID == "" ]]; then
    echo $USAGE
    echo "Missing cluster_id"
    exit 1
fi

CLUSTER_NAME=$ENVIRONMENT-tls-$CLUSTER_ID
TF_WORKSPACE="$ENVIRONMENT-$CLUSTER_ID"

echo $CLUSTER_NAME
echo $TF_WORKSPACE

ROOT_MODULE=$(pwd)/infra/k8s/talos
VARS_DIR=$(pwd)/environments/$ENVIRONMENT/k8s/$CLUSTER_NAME/infra

export TF_WORKSPACE="$TF_WORKSPACE-cluster"
terraform -chdir=$ROOT_MODULE init
terraform -chdir=$ROOT_MODULE destroy -var-file=$VARS_DIR/cluster.tfvars