#!/bin/bash

if [ "$CI_SERVER_HOST" != "gitlab.aws.dev" ]; then 
    source "$(dirname "$0")"/aws-auth.sh
fi 

source "$(dirname "$0")"/terraform-init.sh

terraform -chdir=${TF_DIR} apply -input=false -auto-approve