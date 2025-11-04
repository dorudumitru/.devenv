#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
filter=""
dry="0"

cd "$script_dir" || exit
scripts=$(find ./scripts -maxdepth 1 -mindepth 1 -executable -type f)

log() {
  if [[ $dry == "1" ]]; then
    echo "[DRYRUN]: $*"
  else
    echo "$@"
  fi
}

execute() {
  log "running script: $*"
  if [[ $dry == "1" ]]; then
    return
  fi

  "$@"
}

while [[ $# -gt 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    dry="1"
  else
    filter=$1
  fi

  shift
done

LAST_SCRIPTS="utilities.sh dotfiles.sh"
deferred_scripts=()

for script in $scripts; do
  if echo "$script" | grep -qv "$filter"; then
    continue
  fi

  script_name=$(basename "$script")

  if [[ "$LAST_SCRIPTS" =~ $script_name ]]; then
    deferred_scripts+=("$script")
    continue
  fi

  execute "$script"
done

for script in "${deferred_scripts[@]}"; do
  execute "$script"
done
