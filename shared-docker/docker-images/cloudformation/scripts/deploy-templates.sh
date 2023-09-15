#!/bin/bash

aws cloudformation deploy --template-file ${CF_TEMPLATE_DIR}/packaged.yaml \
    --capabilities CAPABILITY_IAM \
    --stack-name ${STACK_NAME} \
    --profile ${PROFILE}