# GitHub action to push translation files from Lokalise

Use this action to upload all translation files in the base language from your GitHub repository to Lokalise TMS. This action is ideal for performing an initial push, where you upload all available files. After the initial push, you can use the [push action](../push/README.md) to upload only the changed files.

## Usage

Use this action in the following way:

```yaml
name: Initial full push with tags
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
        uses: bodrovis/Lok-Actions/actions/initial_push@master
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

To use this action, you need to configure the following mandatory parameters: `api_token`, `project_id`, `translations_path`, and `file_format`. Refer to the [General setup](../../README.md#general-setup) section for details on these parameters. Additionally, you must specify `base_lang`, which is the base language of your project (e.g., `en` for English).

Optional parameters include:

- `additional_params` — Any additional parameters to pass to the Lokalise CLI when pushing files. For example, you might use `--convert-placeholders` to manage indentation or enter multiple CLI arguments as needed.

## Technical details

### How this action works

When triggered, this action performs the following steps:

1. It finds all translation files for the base language in the specified format under the `translations_path`.
2. It uploads the translation files to the specified project in parallel, handling up to six requests simultaneously.
3. Each translation key is tagged with the name of the branch that triggered the workflow.

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