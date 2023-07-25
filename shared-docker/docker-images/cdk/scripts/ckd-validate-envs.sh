#!/bin/bash

source "$(dirname "$0")"/validate-env-vars.sh

set -e

if [[ -z "$VARIABLES_FOLDER" ]]; then
    echo "VARIABLES_FOLDER must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$TF_DIR" ]]; then
    echo "TF_DIR must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo "AWS_REGION must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$AWS_ACCOUNT" ]]; then
    echo "AWS_ACCOUNT must be provided as environment variable" 1>&2
    exit 1
fi
