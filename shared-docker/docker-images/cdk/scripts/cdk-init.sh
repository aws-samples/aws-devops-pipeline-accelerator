#!/bin/bash

source "$(dirname "$0")"/cdk-set-variables.sh

# terraform -chdir=${TF_DIR} init \
#     -backend-config="bucket=devops-accelerator-state-${AWS_REGION}-${AWS_ACCOUNT}" \
#     -backend-config="key=${PROJECT}/${JOB}.terraform.tfstate" \
#     -backend-config="region=${AWS_REGION}" \
#     -backend-config="dynamodb_table=dynamo-db-devops-accelerator-state-${AWS_REGION}-${AWS_ACCOUNT}" \
#     -backend-config="encrypt=false"


echo "cdk init"