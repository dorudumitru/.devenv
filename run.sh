#!/usr/bin/env bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
filter=""
dry="0"
pm="dnf"

cd "$script_dir" || exit
scripts=$(find ./scripts -maxdepth 1 -mindepth 1 -executable -type f)

usage() {
  cat <<EOF

Usage: ${0} [OPTIONS] [FILTER]

Runs executable scripts found in the './scripts' directory.

Arguments:
  [FILTER]      An optional string used to filter which scripts to run.
                Only scripts whose names contain this string will be executed.

Options:
  --dry         Sets the dry run flag. Scripts will log their intended actions
                but will not actually execute any commands.
  --pm <name>   Specifies the package manager to be used by the scripts.
                Supported names: dnf, pacman, apt.
                Default: dnf
  -h, --help    Display this help message and exit.

EOF
}

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

  "$@" "$pm"
}

while [[ $# -gt 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    dry="1"
  elif [[ $1 == "--pm" ]]; then
    shift
    if [[ $# -gt 0 ]]; then
      pm=$1
    else
      echo "[ERROR]: --pm requires a package manager name (e.g., apt, dnf)." >&2
      exit 1
    fi
  elif [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    usage
    exit 0
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
