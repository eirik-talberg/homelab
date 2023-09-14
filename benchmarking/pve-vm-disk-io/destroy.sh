#!/usr/bin/env bash

set -a
source ../../.env

cd infra || exit

terraform destroy -var-file=.tfvars -auto-approve