# Sample GitHub Actions to facilitate content exchange with Lokalise TMS

This collection of GitHub Actions helps you exchange translation files between Lokalise "Web and mobile" projects and GitHub repositories. It includes the following actions:

- **Initial push:** Upload all translation files (for the base language) from GitHub to Lokalise.
- **Push:** Upload new or updated translation files (for the base language) from GitHub to Lokalise.
- **Pull:** Download translation files (for all languages) from Lokalise to GitHub as a pull request.

## Quickstart

**[Initial push (push all translation files to Lokalise)](./actions/initial_push/README.md):**

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

**[Push new/updated translation files to Lokalise](./actions/push/README.md):**

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

**[Pull translation files from Lokalise (via PR)](./actions/pull/README.md):**

```yaml
name: Demo pull with tags

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

      - name: Pull from Lokalise
        uses: bodrovis/Lok-Actions/actions/pull@master
        with:
          api_token: ${{ secrets.LOKALISE_API_TOKEN }}
          project_id: LOKALISE_PROJECT_ID
          translations_path: TRANSLATIONS_PATH
          file_format: FILE_FORMAT
          additional_params: ADDITIONAL_CLI_PARAMS
```

Refer to the specific action's README for setup details.

## General setup

Every action from this collection requires some general setup.

### Lokalise API token

First, you'll need to generate a read/write [Lokalise API token](https://docs.lokalise.com/en/articles/1929556-api-and-sdk-tokens#h_9ea8e7ff3c) and pass it to the action. For example:

```yaml
- name: Pull from Lokalise
  uses: bodrovis/Lok-Actions/actions/pull@master
  with:
    api_token: ${{ secrets.LOKALISE_API_TOKEN }}
```

**Do not** paste your token directly. Use repository secrets instead:

1. Open repository **Settings**.
2. Go to **Secrets and variables > Actions**.
3. Under **Repository secrets**, click **New repository secret**.
4. Enter `LOKALISE_API_TOKEN` in the **Name** field.
5. Paste your API token into the **Secret** field.
6. That's it! Your token will be securely stored on GitHub and won't be visible during workflow runs.

### Mandatory workflow parameters

You'll also need to provide some mandatory parameters for the workflows. These can be set as environment variables, secrets, or passed directly.

The following parameters are **required for every workflow**:

- `api_token` — Lokalise API token, see above
- `project_id` — Your [Lokalise project ID](https://docs.lokalise.com/en/articles/2136085-project-settings#general)
- `translations_path` — Path to your translations. For example, if your translations are stored in the `locales` folder at the project root, enter `locales` (without a leading forward slash).
- `file_format` — Translation file format. For example, if you're using JSON files, enter `json` (without a leading dot).

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

## Note on cron jobs

You can easily schedule your workflows using cron ([POSIX syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07)). To do that, add a new `schedule` event.

```yaml
on:
  schedule:
    - cron: "0 0 * * *"
```

In this example, the workflow will run every day at midnight. If you need help creating the right schedule, check out this [cron expression generator](https://crontab.guru/).

A few things to keep in mind:

- Scheduled workflows always run on the latest commit from the default or base branch.
- The minimum interval for running scheduled workflows is every 5 minutes.
- You can use `if` conditions to skip specific times: `if: github.event.schedule != '30 5 * * 1,3'`.
- Watch out for [GitHub Actions quotas](https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions). On the Free plan, you get 2000 minutes per month.