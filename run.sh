#!/usr/bin/env bash

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
filter=""
dry="0"
work="0"

detect_distro() {
  if [[ ! -f /etc/os-release ]]; then
    echo "Unable to detect distro: /etc/os-release was not found." >&2
    exit 1
  fi

  # shellcheck disable=SC1091
  source /etc/os-release

  case "${ID:-}" in
  fedora | arch)
    DISTRO="$ID"
    export DISTRO
    ;;
  *)
    echo "Unsupported distro: ${ID:-unknown}. Supported distros: fedora, arch." >&2
    exit 1
    ;;
  esac
}

cd "$current_dir" || exit
personal_scripts=$(find ./scripts/personal -maxdepth 1 -mindepth 1 -executable -type f)
work_scripts=$(find ./scripts/work -maxdepth 1 -mindepth 1 -executable -type f)

usage() {
  cat <<EOF

Usage: ${0} [OPTIONS] [FILTER]

Runs scripts found in the './scripts/personal' directory.
Supports Fedora and Arch Linux only, detected automatically from /etc/os-release.

Arguments:
  [FILTER]      An optional string used to filter which scripts to run.
                Only scripts whose names contain this string will be executed.

Options:
  --dry         Sets the dry run flag. Scripts will log their intended actions
                but will not actually execute any commands.
  --work        Include scripts found in the './scripts/work' directory.
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

  "$@"
}

while [[ $# -gt 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    dry="1"
  elif [[ $1 == "--work" ]]; then
    work="1"
  elif [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    usage
    exit 0
  else
    filter=$1
  fi

  shift
done

detect_distro

if [[ $work == "1" ]]; then
  for script in $work_scripts; do
    if echo "$script" | grep -qv "$filter"; then
      continue
    fi

    script_name=$(basename "$script")
    execute "$script"
  done
else
  LAST_SCRIPTS="utilities.sh dotfiles.sh"
  deferred_scripts=()

  for script in $personal_scripts; do
    if echo "$script" | grep -qv "$filter"; then
      continue
    fi

    script_name=$(basename "$script")

    if [[ "$script_name" == "ssh.sh" && -z "$filter" ]]; then
      continue
    fi

    if [[ "$LAST_SCRIPTS" =~ $script_name ]]; then
      deferred_scripts+=("$script")
      continue
    fi

    execute "$script"
  done

  for script in "${deferred_scripts[@]}"; do
    execute "$script"
  done
fi
