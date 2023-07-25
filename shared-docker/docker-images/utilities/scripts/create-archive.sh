#!/bin/bash
# create zip archive from the path if PATH_TO_ZIP is set and is directory
# create zip archive from the file if FILE_TO_ZIP is set and is not already zip file
set -e

if [[ -z "$BUILD_ARTIFACTS_PATH" ]]; then
    echo "BUILD_ARTIFACTS_PATH must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$ZIP_OUTPUT_FILE_NAME" ]]; then
    echo "ZIP_OUTPUT_FILE_NAME must be provided as environment variable" 1>&2
    exit 1
fi

if [ -z "$FILE_TO_ZIP" ] && [ -z "$PATH_TO_ZIP" ]; then
    echo "FILE_TO_ZIP or PATH_TO_ZIP must be provided as environment variable" 1>&2
    exit 1
fi

echo $BUILD_ARTIFACTS_PATH
echo $ZIP_OUTPUT_FILE_NAME
echo $FILE_TO_ZIP
echo $PATH_TO_ZIP

if [[ ! -z "$PATH_TO_ZIP" ]]; then
  if [ ! -d "${PATH_TO_ZIP}" ]; then
    echo "$PATH_TO_ZIP is not directory"
  fi
  echo "creating ${BUILD_ARTIFACTS_PATH}/${ZIP_OUTPUT_FILE_NAME} from the path ${PATH_TO_ZIP}"
  mkdir -p ${BUILD_ARTIFACTS_PATH}
  zip -r ${BUILD_ARTIFACTS_PATH}/${ZIP_OUTPUT_FILE_NAME} ${PATH_TO_ZIP}
fi

if [[ ! -z "$FILE_TO_ZIP" ]]; then
  if [ "${FILE_TO_ZIP##*.}" == "zip" ]; then
    echo "file $FILE_TO_ZIP is already zipped"
  fi
  echo "creating ${BUILD_ARTIFACTS_PATH}/${ZIP_OUTPUT_FILE_NAME} from the file ${FILE_TO_ZIP}"
  mkdir -p ${BUILD_ARTIFACTS_PATH}
  zip ${BUILD_ARTIFACTS_PATH}/${ZIP_OUTPUT_FILE_NAME} ${FILE_TO_ZIP}
fi
