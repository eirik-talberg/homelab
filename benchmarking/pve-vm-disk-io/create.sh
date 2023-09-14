#!/usr/bin/env bash

set -a
source ../../.env

ansible-playbook -i ../../ansible/inventories/homelab setup-host.yaml

cd infra || exit

echo "Provisioning environment"

terraform init
terraform plan -var-file=.tfvars
terraform apply -var-file=.tfvars -auto-approve