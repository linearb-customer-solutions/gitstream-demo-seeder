#!/bin/bash
set -euo pipefail
set -x  # 👈 Echo all commands as they run

# === Random commit date generation (past 90 days) ===
generate_commit_date() {
  local offset=$((RANDOM % 90))
  [[ "$OSTYPE" == "darwin"* ]] && date -v-"$offset"d -u "+%Y-%m-%dT%H:%M:%S" || date -u -d "$offset days ago" "+%Y-%m-%dT%H:%M:%S"
}

# === Commit Wrapper ===
commit_with_env() {
  local msg="$1" username="$2" email="$2@users.noreply.github.com" date=$(generate_commit_date)
  GIT_COMMITTER_DATE="$date" \
  GIT_AUTHOR_DATE="$date" \
  env GIT_COMMITTER_NAME="$username" GIT_COMMITTER_EMAIL="$email" \
  git commit -m "$msg" --author="$username <$email>"
}

# === Clean and Prepare Target ===
rm -rf rewritten-demo 
mkdir rewritten-demo
cp -r gitstream-automation-demo-main/demo-app/. rewritten-demo/
cd rewritten-demo
git config --global init.defaultBranch main
git config --global user.name "GitHub Actions Bot"
git config --global user.email "actions@github.com"
git init
git remote add origin "${TARGET_REPO}"

# === Add Grouped Commits ===
git add frontend/ && commit_with_env "Implement frontend UI" "${FRONTEND_COMMITTER_USERNAME:-amitmohleji}"
git add services/auth-python/ && commit_with_env "Add Python auth service" "${SERVICE_COMMITTER_USERNAME:-cghyzel}"
git add services/billing-csharp/ && commit_with_env "Add C# billing service" "${SERVICE_COMMITTER_USERNAME:-cghyzel}"
git add services/orders-java/ && commit_with_env "Add Java orders service" "${SERVICE_COMMITTER_USERNAME:-cghyzel}"
git add .github/ .cm/ docker-compose.yml && commit_with_env "Infra + gitStream config" "${META_COMMITTER_USERNAME:-HeatherHazell}"
git add README.md && commit_with_env "Add README" "${META_COMMITTER_USERNAME:-HeatherHazell}"

# === Push Main ===
git push origin main --force

# === Delete Remote Branches Except Main ===
for branch in $(git ls-remote --heads origin | awk '{print $2}' | sed 's/refs\/heads\///'); do
  if [[ "$branch" != "main" ]]; then
    echo "💣 Deleting remote branch: $branch"
    git push origin --delete "$branch" || true
  fi
done

# === PR Branches ===
branch="base-kit"
git checkout -b $branch
cp -r ../gitstream-automation-demo-new-feature/demo-app/* .
git add .
commit_with_env "Feature: order history" "${PR_COMMITTER_USERNAME:-vlussenburg}"
git push --force origin $branch
gh pr create --base main --head "$branch" --title "Demo Base Kit" --body ""
git checkout main

branch="efficiency-kit"
git checkout -b $branch
echo '# Just some safe documentation changes!' >> README.md
git add README.md
commit_with_env "Apply shared service TODO update on code-update-efficiency" "${PR_COMMITTER_USERNAME:-vlussenburg}"
git push --force origin $branch
gh pr create --base main --head "$branch" --title "Demo Efficiency Kit" --body ""
git checkout main

branch="quality-kit"
git checkout -b $branch
cp -r ../gitstream-automation-demo-new-feature/demo-app/* .
git add .
commit_with_env "Feature: order history" "${PR_COMMITTER_USERNAME:-vlussenburg}"
git push --force origin $branch
gh pr create --base main --head "$branch" --title "Demo Quality Kit" --body ""
git checkout main

branch="standardization-kit"
git checkout -b $branch
cp -r ../gitstream-automation-demo-new-feature/demo-app/* .
git add .
commit_with_env "Feature: order history" "${PR_COMMITTER_USERNAME:-vlussenburg}"
git push --force origin $branch
gh pr create --base main --head "$branch" --title "Demo Standardization Kit" --body ""
git checkout main