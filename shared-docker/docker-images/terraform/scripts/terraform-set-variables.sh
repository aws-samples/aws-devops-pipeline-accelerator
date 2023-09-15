#!/bin/bash

source "$(dirname "$0")"/terraform-validate-envs.sh

if [ -f "${TF_DIR}/${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars" ]; then
    export "TF_CLI_ARGS_plan=-var-file=${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars"
    export "TF_CLI_ARGS_deploy=-var-file=${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars"
    export "TF_CLI_ARGS_apply=-var-file=${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars"
    export "TF_CLI_ARGS_destroy=-var-file=${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars"
else
  echo "Environment variables are not set properly! It can be done by creating file: ${TF_DIR}/${VARIABLES_FOLDER}/${ENVIRONMENT}-${JOB}.tfvars"
fi

export "TF_VAR_name=${PROJECT}-${JOB}"
export "TF_VAR_environment=${ENVIRONMENT}"
export "TF_VAR_AWS_ACCOUNT=${AWS_ACCOUNT}"
