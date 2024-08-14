# Sample GitHub Actions to facilitate content exchange with Lokalise TMS

Push and pull is currently supported.

If you're using the default GITHUB_TOKEN, ensure it has the right permissions. By default, the token's permissions might be limited:

    Go to your repository's Settings > Actions > General.
    Under "Workflow permissions," make sure the setting is set to Read and write permissions.



    Choose whether GitHub Actions can create pull requests or submit approving pull request reviews.
Allow GitHub Actions to create and approve pull requests


make sure to assign proper filenames to keys on Lokalise. if your directory in project is locales/%LANG_ISO%/, then the filenames must be locales/%LANG_ISO%/FILENAME
