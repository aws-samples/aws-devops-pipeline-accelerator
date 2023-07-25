#!/bin/bash

set -e

if [[ -z "$CF_TEMPLATE" ]]; then
    echo "CF_TEMPLATE must be provided as environment variable" 1>&2
    exit 1
fi

# if [[ -z "$ENVIRONMENT" ]]; then
#     echo "ENVIRONMENT must be provided as environment variable" 1>&2
#     exit 1
# fi

if [[ -z "$JOB" ]]; then
    echo "JOB must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$PROJECT" ]]; then
    echo "PROJECT must be provided as environment variable" 1>&2
    exit 1
fi

if [[  "$1" == "local" ]]; then

  if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
      echo "AWS_ACCESS_KEY_ID should be provided as environment variable" 1>&2
      exit 1
  fi

  if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
      echo "AWS_SECRET_ACCESS_KEY should be provided as environment variable" 1>&2
      exit 1
  fi

  if [[ -z "$AWS_SESSION_TOKEN" ]]; then
      echo "AWS_SESSION_TOKEN should be provided as environment variable" 1>&2
      exit 1
  fi

else

  if [[ -z "$ROLE_ARN" ]]; then
      echo "ROLE_ARN must be provided as environment variable" 1>&2
      exit 1
  fi

  if [[ -z "$CI_PROJECT_ID" ]]; then
      echo "CI_PROJECT_ID must be provided as environment variable" 1>&2
      exit 1
  fi

  if [[ -z "$CI_PIPELINE_ID" ]]; then
      echo "CI_PIPELINE_ID must be provided as environment variable" 1>&2
      exit 1
  fi

  if [[ -z "$AWS_WEB_ITENTITY_TOKEN" ]]; then
      echo "AWS_WEB_ITENTITY_TOKEN must be provided as environment variable" 1>&2
      exit 1
  fi

fi
