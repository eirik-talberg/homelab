#! /bin/bash

set -e

MODULE=$(pwd)/infra/hcp/vault-secrets
PROJECT=hcp-vault-secrets

terraform -chdir=$MODULE init
terraform -chdir=$MODULE plan -out=$PROJECT.tfplan
terraform -chdir=$MODULE apply $PROJECT.tfplan