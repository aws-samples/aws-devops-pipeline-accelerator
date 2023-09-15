set -e

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "OUTPUT_DIR must be provided as environment variable" 1>&2
    exit 1
fi

if [[ -z "$ZIP_FILE_NAME" ]]; then
    echo "ZIP_FILE_NAME must be provided as environment variable" 1>&2
    exit 1
fi

echo $ZIP_FILE_NAME
echo $OUTPUT_DIR

mkdir -p ${OUTPUT_DIR}
unzip ${ZIP_FILE_NAME} -d ${OUTPUT_DIR}