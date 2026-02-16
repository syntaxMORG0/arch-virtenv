#!/bin/bash
# generate_gh_link.sh: Generates a GitHub link for the repository

set -e

REPO_URL=$(git config --get remote.origin.url)

if [ -z "$REPO_URL" ]; then
    echo "No remote origin URL found."
    exit 1
fi

echo "GitHub repository link: $REPO_URL"
