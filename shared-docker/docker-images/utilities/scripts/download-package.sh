set -e

if [[ -z "$CI_JOB_TOKEN" ]]; then
    echo "CI_JOB_TOKEN must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$OUTPUT_FILE_NAME" ]]; then
    echo "OUTPUT_FILE_NAME must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$ARTIFACT_PACKAGE_URL" ]]; then
    echo "ARTIFACT_PACKAGE_URL must be provided as environment variable" 1>&2
    exit 1
fi

echo $OUTPUT_FILE_NAME
echo $ARTIFACT_PACKAGE_URL

curl --silent --output ${OUTPUT_FILE_NAME} --header "JOB-TOKEN: $CI_JOB_TOKEN" ${ARTIFACT_PACKAGE_URL}