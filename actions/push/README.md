# GitHub action to push changed translation files from Lokalise

Use this action to upload changed translation files in the base language from your GitHub repository to Lokalise TMS.

## Usage

Use this action in the following way:

```yaml
name: Demo push with tags
on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Push to Lokalise
        uses: bodrovis/Lok-Actions/actions/push@master
        with:
          api_token: ${{ secrets.LOKALISE_API_TOKEN }}
          project_id: LOKALISE_PROJECT_ID
          base_lang: BASE_LANG_ISO
          translations_path: TRANSLATIONS_PATH
          file_format: FILE_FORMAT
          additional_params: ADDITIONAL_CLI_PARAMS
```

## Configuration

### Parameters

The following mandatory parameters are covered in the [General setup](../../README.md#general-setup):

- **`api_token`** — Lokalise API token.
- **`project_id`** — Your Lokalise project ID.
- **`translations_path`** — Path to your translation files.
- **`file_format`** — The format of your translation files.

In addition to the above, there are other mandatory parameters:

- **`base_lang`** — The base language of your project (e.g., `en` for English). Be mindful of regional codes! If your base language is French Canada (`fr_CA`), you must provide the exact value for `base_lang`. Also, ensure the nested folder under `translations_path` is named `fr_CA`. For more details on file organization, check the [Translation files](../../README.md#translation-files) section.

Optional parameters include:

- **`additional_params`** — Extra parameters to pass to the [Lokalise CLI when pushing files](https://github.com/lokalise/lokalise-cli-2-go/blob/main/docs/lokalise2_file_upload.md). For example, you can use `--convert-placeholders` to handle placeholders. You can include multiple CLI arguments as needed.

## Technical details

### How this action works

When triggered, this action performs the following steps:

1. Detects all changed translation files since the previous commit for the base language in the specified format under the `translations_path`.
2. Uploads modified translation files to the specified project in parallel, handling up to six requests simultaneously.
3. Each translation key is tagged with the name of the branch that triggered the workflow.

If no changes have been detected in step 1, the following logic applies:

1. The action checks if this is the first run on the triggering branch. To achieve that, it searches for a `[Lokalise-Upload-Complete]` commit.
   - If this commit is found, it means that the initial push has already been completed. The action will then exit.
2. If the commit is not found, the action will perform an initial push to Lokalise by uploading all translation files for the base language.
3. The action creates an empty `[Lokalise-Upload-Complete]` commit, indicating that the initial setup has been successfully completed.
   - It is heavily recommended to pull changes from the triggering branch to your local repo to include this commit into your local history.

For more information on assumptions, refer to the [Assumptions and defaults](../../README.md#assumptions-and-defaults) section.

### Default parameters for the push action

By default, the following command-line parameters are set when uploading files to Lokalise:

- `--token` — Derived from the `api_token` parameter.
- `--project-id` — Derived from the `project_id` parameter.
- `--file` — The currently uploaded file.
- `--lang-iso` — The language ISO code of the translation file.
- `--replace-modified`
- `--include-path`
- `--distinguish-by-file`
- `--poll`
- `--poll-timeout` — Set to `120s`.
- `--tag-inserted-keys`
- `--tag-skipped-keys=true`
- `--tag-updated-keys`
- `--tags` — Set to the branch name that triggered the workflow.
