# Sample GitHub Actions to facilitate content exchange with Lokalise TMS

Push and pull are currently supported through tags and Lokalise branches. Use with "Web and mobile" projects to easily exchange your content.

## Table of Contents

- [Setup](#setup)
  - [Lokalise API token](#lokalise-api-token)
  - [Mandatory workflow parameters](#mandatory-workflow-parameters)
  - [Optional workflow parameters](#optional-workflow-parameters)
  - [Setting up permissions](#setting-up-permissions)
- [Running the workflows](#running-the-workflows)
- [Assumptions and defaults](#assumptions-and-defaults)
  - [Translation files](#translation-files)
  - [Default parameters for the push action](#default-parameters-for-the-push-action)
  - [Default parameters for the pull action](#default-parameters-for-the-pull-action)

## Setup

### Lokalise API token

First, you'll need to provide your [Lokalise API token](https://docs.lokalise.com/en/articles/1929556-api-and-sdk-tokens#h_9ea8e7ff3c) in the repository secrets:

1. Open repository **Settings**.
2. Go to **Secrets and variables > Actions**.
3. Under **Repository secrets**, click **New repository secret**.
4. Enter `LOKALISE_API_TOKEN` in the **Name** field.
5. Paste your API token into the **Secret** field.
6. That's it! Your token will be securely stored on GitHub and won't be visible during workflow runs.

### Mandatory workflow parameters

You'll also need to provide some mandatory parameters for the workflow. These are set as environment variables:

1. Go to the repository **Settings**.
2. Navigate to **Secrets and variables > Actions**.
3. Switch to the **Variables** tab.
4. Click **New repository variable**.
5. Fill in the variable's name and value.

You'll need to create the following variables:

- `LOKALISE_TRANSLATIONS_PATH` — Path to your translations. For example, if your translations are stored in the `locales` folder at the project root, enter `locales` (without a leading forward slash).
- `LOKALISE_FILE_FORMAT` — Translation file format. For example, if you're using JSON files, enter `json` (without a leading dot).
- `LOKALISE_PROJECT_ID` — Your [Lokalise project ID](https://docs.lokalise.com/en/articles/2136085-project-settings#general).
- `LOKALISE_SOURCE_LANG` — Project base language. For example, if your base language is English, enter `en`.
- `LOKALISE_BRANCH_MARKER` — This parameter is mandatory only if you're using pull actions. The value entered will become part of the branch name to create the pull request from. For example, you can enter `lok`.
- `GIT_UPSTREAM_BRANCH` — Mandatory only if you're using push actions with branches. Provide the branch name to use as upstream. For example, enter `main` or `master`.

### Optional workflow parameters

Optional parameters are set the same way as the mandatory ones:

- `LOKALISE_PULL_ADDITIONAL_PARAMS` — Any additional parameters to pass to the Lokalise CLI when pulling files. For example, to manage indentation, enter `--indentation 2sp`. You can enter multiple CLI arguments if needed.
- `LOKALISE_PUSH_ADDITIONAL_PARAMS` — Any additional parameters to pass to the Lokalise CLI when pushing files. For example, to convert placeholders to universal ones and run automations, enter `--convert-placeholders --use-automations`. You can enter multiple CLI arguments if needed.

### Setting up permissions

1. Go to your repository's **Settings**.
2. Navigate to **Actions > General**.
3. Under **Workflow permissions**, ensure the setting is set to **Read and write permissions**.

If you're planning to use pull actions to create pull requests, also make sure to tick **Allow GitHub Actions to create and approve pull requests** on the same page (under "Choose whether GitHub Actions can create pull requests or submit approving pull request reviews").

## Running the workflows

To run a workflow:

1. Open your GitHub repository and go to **Actions**.
2. Select a workflow from the left pane.
3. Find the **Run workflow** dropdown on the right side.
4. Choose a branch to trigger the workflow for.
5. Click **Run workflow**.

## Assumptions and defaults

### Translation files

This workflow assumes that inside the translation folder (provided using the `LOKALISE_TRANSLATIONS_PATH`), you have nested folders named after your project locales. For example, if your `LOKALISE_SOURCE_LANG` is set to `en`, there should be a folder with the same name. Here's a sample directory structure:

```
locales/
├── en/
│   ├── main.json
│   └── admin.json
└── fr/
    ├── main.json
    └── admin.json
```

When managing your translation keys on Lokalise, ensure proper filenames are assigned to these keys. The filenames should match the structure in your repository. For example, if you store translations under `locales/%LANG_ISO%/`, then the filename assigned to the corresponding key must be `locales/%LANG_ISO%/TRANSLATION_FILE_NAME`.

### Default parameters for the push action

By default, the following command-line parameters are set when uploading files to Lokalise:

- `--token` — Read from the `LOKALISE_API_TOKEN` secret.
- `--project-id` — Read from the `LOKALISE_PROJECT_ID` variable.
- `--file` — The currently uploaded file.
- `--lang-iso` — The language ISO of the translation file.
- `--replace-modified`
- `--include-path`
- `--distinguish-by-file`
- `--poll`
- `--poll-timeout` — Set to `120s`.
- `--tag-inserted-keys`
- `--tag-skipped-keys=true`
- `--tag-updated-keys`
- `--tags` — Set to the branch name that triggered the workflow.

### Default parameters for the pull action

By default, the following command-line parameters are set when downloading files from Lokalise:

- `--token` — Read from the `LOKALISE_API_TOKEN` secret.
- `--project-id` — Read from the `LOKALISE_PROJECT_ID` variable.
- `--format` — Read from the `LOKALISE_FILE_FORMAT` variable.
- `--original-filenames` — Set to `true`.
- `--directory-prefix` — Set to `/`.
- `--include-tags` — Set to the branch name that triggered the workflow.