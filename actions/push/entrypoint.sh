#!/bin/bash
set -e

LOKALISE_API_TOKEN="${{ inputs.lokalise_api_token }}"
LOKALISE_PROJECT_ID="${{ inputs.lokalise_project_id }}"
LOKALISE_SOURCE_LANG="${{ inputs.lokalise_source_lang }}"
LOKALISE_TRANSLATIONS_PATH="${{ inputs.lokalise_translations_path }}"
LOKALISE_FILE_FORMAT="${{ inputs.lokalise_file_format }}"
LOKALISE_CLI_ADD_PARAMS="${{ inputs.lokalise_push_additional_params }}"

echo "LOKALISE_API_TOKEN=$LOKALISE_API_TOKEN" >> $GITHUB_ENV
echo "LOKALISE_PROJECT_ID=$LOKALISE_PROJECT_ID" >> $GITHUB_ENV
echo "LOKALISE_SOURCE_LANG=$LOKALISE_SOURCE_LANG" >> $GITHUB_ENV
echo "LOKALISE_TRANSLATIONS_PATH=$LOKALISE_TRANSLATIONS_PATH" >> $GITHUB_ENV
echo "LOKALISE_FILE_FORMAT=$LOKALISE_FILE_FORMAT" >> $GITHUB_ENV
echo "LOKALISE_CLI_ADD_PARAMS=$LOKALISE_CLI_ADD_PARAMS" >> $GITHUB_ENV

chmod +x .github/scripts/*.sh
. ./.github/scripts/lokalise_upload.sh