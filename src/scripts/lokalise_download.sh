#!/bin/bash

download_files() {
    local project_id_with_branch=$1
    local token=$2
    local additional_params="${CLI_ADD_PARAMS:-}"
    local attempt=0
    local max_retries="${MAX_RETRIES:-5}"
    local sleep_time="${SLEEP_TIME:-1}"
    local max_total_time=300
    local start_time=$(date +%s)

    echo "Starting download for project: $project_id_with_branch"
    while [ $attempt -lt $max_retries ]; do
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        if [ $elapsed_time -ge $max_total_time ]; then
            echo "Max retry time exceeded. Exiting."
            return 1
        fi

        echo "Attempt $((attempt + 1)) of $max_retries"

        set +e  # Temporarily disable exit on error

        output=$(./bin/lokalise2 --token="$token" \
            --project-id="$project_id_with_branch" \
            file download \
            --format="${FILE_FORMAT}" \
            --original-filenames=true \
            --directory-prefix="/" \
            --include-tags="${GITHUB_REF_NAME}" \
            $additional_params 2>&1)

        exit_code=$?

        set -e  # Re-enable exit on error

        if [ $exit_code -eq 0 ]; then
            echo "Successfully downloaded files"
            return 0
        elif echo "$output" | grep -q 'API request error 429'; then
            attempt=$((attempt + 1))
            echo "Attempt $attempt failed with API request error 429. Retrying in $sleep_time seconds..."
            sleep $sleep_time
            sleep_time=$((sleep_time * 2))
        elif echo "$output" | grep -q 'API request error 406'; then
            echo "API request error 406: No keys for export with current export settings. Exiting..."
            return 0
        else
            echo "Error encountered during download: $output"
            return 1
        fi
    done

    echo "Failed to download files after $max_retries attempts"
    return 1
}
