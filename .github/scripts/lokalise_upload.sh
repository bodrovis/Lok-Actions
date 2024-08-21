#!/bin/bash

upload_file() {
    local file=$1
    local project_id_with_branch=$2
    local lang_iso=$3
    local additional_params="${LOKALISE_CLI_ADD_PARAMS:-}"
    local attempt=0
    local max_retries=3
    local sleep_time=1

    echo "Starting upload for $file"
    while [ $attempt -lt $max_retries ]; do
        output=$(./bin/lokalise2 --token="${LOKALISE_API_TOKEN}" \
            --project-id="$project_id_with_branch" \
            file upload \
            --file="$file" \
            --lang-iso="$lang_iso" \
            --replace-modified \
            --include-path \
            --distinguish-by-file \
            --poll \
            --poll-timeout=120s \
            --tag-inserted-keys \
            --tag-skipped-keys=true \
            --tag-updated-keys \
            --tags "$GITHUB_REF_NAME" \
            $additional_params 2>&1)

        if [ $? -eq 0 ]; then
            echo "Successfully uploaded $file"
            return 0
        elif echo "$output" | grep -q 'API request error 429'; then
            attempt=$((attempt + 1))
            echo "Attempt $attempt failed with API request error 429. Retrying in $sleep_time seconds..."
            sleep $sleep_time
            sleep_time=$((sleep_time * 2))
        else
            echo "Permanent error encountered during upload: $output"
            return 1
        fi
    done

    echo "Failed to upload file: $file after $max_retries attempts"
    return 1
}
