#!/usr/bin/env bash

set -e

# Do not deploy if it's a pull request
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo Skipping deploy because pull request
  exit 0
fi

case "$TRAVIS_BRANCH" in
  development)
    ;;
  travis)
    ;;
  *)
    echo Skipping deploy because not a selected branch
    exit 0

esac

cd build
git init
git config user.name "Travis CI"
git config user.email "me@russellhay.com"

git add .
git commit -m "auto-commit via travis"

if [ -z "$PUSH_DEBUG"]; then
git push --force --quiet "https://${GH_DEPLOYER}:${GH_TOKEN}@${GH_REPO}" development:gh-pages 
else
git push --force --quiet "https://${GH_DEPLOYER}:${GH_TOKEN}@${GH_REPO}" development:gh-pages > /dev/null 2>&1
fi
