#!/bin/bash

source "$(dirname "$0")"/validate-env-vars.sh

if [[  "$1" == "local" ]]; then

  echo "Running locally"

else

  echo "$ROLE_ARN"

  STS=($(aws sts assume-role-with-web-identity \
      --role-arn $ROLE_ARN \
      --role-session-name "GitLab-${CI_PROJECT_ID}-${CI_PIPELINE_ID}" \
      --web-identity-token ${AWS_WEB_ITENTITY_TOKEN} \
      --duration-seconds ${STS_TOKEN_DURATION:-900} \
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
      --output text))

  export "AWS_ACCESS_KEY_ID=${STS[0]}"
  export "AWS_SECRET_ACCESS_KEY=${STS[1]}"
  export "AWS_SESSION_TOKEN=${STS[2]}"

  export -p > aws_env_vars.sh

fi