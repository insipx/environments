{writeShellScriptBin}:
writeShellScriptBin "jj-gt" ''
  #!/bin/bash

  # Exit immediately if a command exits with a non-zero status
  set -e

  jj fix

  # Get the list of mutable branches that are reachable from the current branch
  # (i.e. that are between us and main).
  branches=$(jj bookmark list -r 'reachable(@,mutable())' --template 'name ++ "\n"')

  # Loop through each branch and track it in Graphite
  for branch in $branches; do
    # Track the branch using the most recent ancestor branch as the parent
    gt track --force "$branch"
  done

  # Check if the working directory is dirty
  if [ "$(jj diff --summary | wc -l)" -gt 1 ]; then
    jj new
  fi

  latest_branch=$(echo "$branches" | tail -n 1)

  HUSKY=0 gt checkout $latest_branch

  # Get the repo root and run pre-commit hooks if they exist
  repo_root=$(git rev-parse --show-toplevel)
  if [ -f "$repo_root/.husky/pre-commit" ]; then
    pushd "$repo_root" > /dev/null
    sh .husky/pre-commit
    popd > /dev/null
  fi

  gt submit
''
