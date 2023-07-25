#!/bin/bash

source "$(dirname "$0")"/terraform-set-variables.sh

terraform -chdir=${TF_DIR} init \
    -backend-config="bucket=dpa-state-${AWS_REGION}-${AWS_ACCOUNT}" \
    -backend-config="key=${PROJECT}/${JOB}.terraform.tfstate" \
    -backend-config="region=${AWS_REGION}" \
    -backend-config="dynamodb_table=dynamo-db-dpa-state-${AWS_REGION}-${AWS_ACCOUNT}" \
    -backend-config="encrypt=false"
