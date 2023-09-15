#!/bin/bash

echo $(cfn-lint -t ${CF_TEMPLATES_PATH}/*.yaml --format junit) > ${LINT_RESULTS_FILE}