#!/bin/bash

# source "$(dirname "$0")"/aws-auth.sh 

find "${CF_TEMPLATE_DIR}" -type f \( -name '*.yaml' -o -name '*.yml' \) -print0 | while IFS= read -r -d '' CF_TEMPLATE_FILE; do 
    echo "Validating template - ${CF_TEMPLATE_FILE}"
    aws cloudformation validate-template --template-body "file://${CF_TEMPLATE_FILE}"
done  

