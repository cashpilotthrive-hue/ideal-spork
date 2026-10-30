# DevSecOps Security Console

A lightweight static dashboard for the account's selected application repositories.

## Current scope
- `openai-chatkit-starter-app`
- `next-saas-stripe-starter`

The page reads public GitHub Actions run metadata from the GitHub API. It does not expose secrets or replace GitHub's Security tab, CodeQL alerts, or workflow artifacts.

## Enable hosting
After merging this pull request, enable GitHub Pages for this repository using **Settings → Pages → Deploy from a branch**, select the default branch and `/security-console` as the publishing folder if supported by the repository's Pages configuration. Alternatively, configure a Pages workflow to publish this directory.

## DAST setup in each application repository
Add Actions secrets:
- `BURP_ENTERPRISE_SERVER_URL`
- `BURP_ENTERPRISE_API_KEY`

Add Actions variables:
- `BURP_STAGING_URL`
- `BURP_PRODUCTION_URL`
- `BURP_SCANNER_IMAGE` (must match your deployed Burp DAST server version)
- `BURP_OUT_OF_SCOPE_URLS` (optional)

Create GitHub Environments named `staging-security-scan` and `production-security-scan`; require reviewers for production. Only configure targets you own or are explicitly authorized to test. DAST remains skipped on normal events until a staging URL is configured.
