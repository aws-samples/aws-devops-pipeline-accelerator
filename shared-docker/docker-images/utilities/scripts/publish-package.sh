set -e

if [[ -z "$CI_JOB_TOKEN" ]]; then
    echo "CI_JOB_TOKEN Must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$UPLOAD_FILE" ]]; then
    echo "UPLOAD_FILE Must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$ARTIFACT_PACKAGE_URL" ]]; then
    echo "ARTIFACT_PACKAGE_URL Must be provided as environment variable" 1>&2
    exit 1
fi

echo $UPLOAD_FILE
echo $ARTIFACT_PACKAGE_URL

# check if already exists
status_code=$(curl --write-out %{http_code} --silent --output /dev/null --header "JOB-TOKEN: $CI_JOB_TOKEN" ${ARTIFACT_PACKAGE_URL})

echo $status_code

# publish generic package if not exists in the package registry
if [[ $status_code -eq 200 ]] ; then
  echo "Package already published. Nothing to publish."
else
  curl -i -s --fail --show-error --header "JOB-TOKEN: $CI_JOB_TOKEN" --upload-file ${UPLOAD_FILE} "${ARTIFACT_PACKAGE_URL}"
fi
