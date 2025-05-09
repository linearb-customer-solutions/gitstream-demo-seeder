# gitstream-demo-seeder

This repository serves as the **source of truth** for generating and maintaining GitStream demo repositories — such as [`gitstream-demo`](https://github.com/linear-b/gitstream-demo).

## 🧪 Purpose

The goal is to automate the reconstruction of a demo repository with:

- Clean, controlled commit history
- Multiple contributors (with customizable usernames/emails)
- Predefined PR branches demonstrating GitStream use cases (e.g. Efficiency, Quality, Standardization)
- Support for GitHub Actions automation and realistic blame/commit history

## 🔄 How It Works

- This repo contains:
  - All demo application source files under [`demo-app/`](./demo-app/)
  - A `rewrite.sh` script that:
    - Rebuilds the target demo repo from scratch
    - Injects realistic commit history and authorship
    - Applies feature branches
    - Purges remote branches except `main` (which autocloses PRs)
    - Pushes clean branches and reopens PRs


## 🚀 Setup

Before running the script, ensure the following environment variables are set (via GitHub Actions or shell):

| Variable                     | Description                          |
|-----------------------------|--------------------------------------|
| `TARGET_REPO`               | Git URL of the demo repo to rebuild  |
| `SERVICE_COMMITTER_USERNAME`| Username for service-related commits |
| `META_COMMITTER_USERNAME`   | Username for infrastructure commits  |
| `FRONTEND_COMMITTER_USERNAME`| Username for frontend commits       |
| `PR_COMMITTER_USERNAME`     | Username for PR-related changes      |

> All commit emails are generated as `${USERNAME}@users.noreply.github.com`.

These can be provided via [GitHub Repository Variables](https://github.com/<org>/<repo>/settings/variables/actions).

## 🛠️ Usage

1. Clone this repo locally or run via GitHub Actions.
2. Run `bootstrap_demo_repo.sh`
3. The target demo repo will be force-pushed with:
   - Realistic commit structure
   - Contributor attribution
   - Three open PRs showcasing GitStream automations

## 📦 Output Repo

This repo is meant to generate and manage:

➡️ [`gitstream-demo`](https://github.com/linear-b/gitstream-demo)

---

Maintained by the Productivity team @ LinearB.