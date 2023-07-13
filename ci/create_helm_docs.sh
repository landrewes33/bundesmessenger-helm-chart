#!/bin/sh

# Script to create `docs/standard_values.md` with helm-docs
# Splits `values.xml` in multiple parts and merge the results.
# helm-docs is required in PATH.

INPUT_FILE=values.yaml
NEEDLE="##[[:space:]][[:space:]][[:space:]][[:space:]][[:space:]][[:space:]][[:space:]][[:space:]][[:space:]][[:space:]]"

echo "Running \"helm-docs\" to update docs"

echo "Create header"
helm-docs --values-file=${INPUT_FILE} --output-file=${HELM_DOCS_OUTPUT_FILE} --template-files=${HELM_DOCS_TEMPLATE_HEADER}
mkdir ./tmp/

echo "Split ${INPUT_FILE}"
csplit -f ./tmp/splitfile_ $INPUT_FILE "/$NEEDLE/" "{$(($(grep -c -E $NEEDLE $INPUT_FILE)-1))}"

line_numbers_add=0
for file in ./tmp/splitfile_*; do
    line_numbers_file=$(wc -l < $file)

    # ignore first file / to small
    filesize=$(stat -c %s $file)
    if [ $filesize -gt 150 ]; then
        # first row
        headline=$(head -n 1 ${file})
        # trim `##`
        headline=${headline:2}
        # trim spaces
        headline=$(echo $headline | xargs)

        # add lines to correct the line numbers in values.yaml
        for i in $(seq 1 $line_numbers_add); do
            sed -i -e1i#added_line_$i $file
        done

        echo "$headline => $file (added lines: $line_numbers_add)"
        helm-docs --values-file=${file} --output-file=${file}_doc --template-files=${HELM_DOCS_TEMPLATE_VALUES} --sort-values-order=file
        sed --in-place "s/###HEADLINE###/$headline/" ${file}_doc

        cat ${file}_doc >> ${HELM_DOCS_OUTPUT_FILE}
    fi
    let "line_numbers_add+=line_numbers_file"
done

echo "Create footer"
helm-docs --values-file=${INPUT_FILE} --output-file=./tmp/footer_doc --template-files=${HELM_DOCS_TEMPLATE_FOOTER}

cat ./tmp/footer_doc >> ${HELM_DOCS_OUTPUT_FILE}
rm -rf ./tmp/

echo "Helm-Docs successfully updated."