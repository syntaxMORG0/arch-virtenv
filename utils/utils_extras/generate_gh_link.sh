#!/bin/bash
# generate_gh_link.sh: Generates a GitHub link for the repository

set -e


echo "[GHCS]: Generating GitHub repository link..."
REPO_URL=$(git config --get remote.origin.url)


if [ -z "$REPO_URL" ]; then
    echo "[GHCS]: No remote origin URL found."
    exit 1
fi

echo "GitHub repository link: $REPO_URL"
echo "[GHCS]: GitHub repository link generated: $REPO_URL"
