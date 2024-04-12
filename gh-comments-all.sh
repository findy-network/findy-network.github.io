#!/bin/bash

pull_number=${1:-`gh pr view --json 'number' --jq '.number'`}
owner=`gh repo view --json 'owner' --jq '.owner.login'`
name=`gh repo view --json 'name' --jq '.name'`

repo_info="$owner/$name"

#echo "/repos/$repo_info/pulls/$pull_number/comments"

gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$repo_info/pulls/$pull_number/comments | jq -r '.[] | [.path, .original_line, .body] | join(":")'
#  /repos/$repo_info/pulls/$pull_number/comments | jq '.[].body'
