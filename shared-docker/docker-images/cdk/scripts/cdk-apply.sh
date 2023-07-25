#!/bin/bash

source "$(dirname "$0")"/aws-auth.sh
source "$(dirname "$0")"/cdk-init.sh

# terraform -chdir=${TF_DIR} apply -input=false -auto-approve
echo "cdk apply"