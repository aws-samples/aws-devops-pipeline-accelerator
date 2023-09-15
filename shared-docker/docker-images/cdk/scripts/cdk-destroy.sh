#!/bin/bash

source "$(dirname "$0")"/aws-auth.sh
source "$(dirname "$0")"/terraform-init.sh

# terraform -chdir=${TF_DIR} destroy -auto-approve
echo "cdk destroy"