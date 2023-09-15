#!/bin/bash

echo $(cfn_nag_scan --input-path ${CF_TEMPLATES_PATH} --output-format json) > ${CFN_NAG_RESULTS_FILE}