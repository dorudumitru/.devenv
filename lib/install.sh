#!/usr/bin/env bash

devenv_fail() {
  echo "$*" >&2
  exit 1
}

if [[ -z "${DISTRO:-}" ]]; then
  devenv_fail "DISTRO is not set. Run scripts through ./run.sh or export DISTRO=fedora|arch."
fi

case "$DISTRO" in
fedora | arch)
  ;;
*)
  devenv_fail "Unsupported distro: $DISTRO. Supported distros: fedora, arch."
  ;;
esac

is_fedora() {
  [[ "$DISTRO" == "fedora" ]]
}

is_arch() {
  [[ "$DISTRO" == "arch" ]]
}

install_packages() {
  if is_fedora; then
    sudo dnf install -y "$@"
    return
  fi

  sudo pacman -S --needed --noconfirm "$@"
}

remove_packages() {
  if is_fedora; then
    sudo dnf remove -y "$@"
    return
  fi

  sudo pacman -Rns --noconfirm "$@"
}

enable_service() {
  sudo systemctl enable "$1"
}

start_service() {
  sudo systemctl start "$1"
}

enable_now_service() {
  sudo systemctl enable --now "$1"
}

aur_user() {
  if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != "root" ]]; then
    echo "$SUDO_USER"
    return
  fi

  if [[ "$(id -un)" != "root" ]]; then
    id -un
    return
  fi

  devenv_fail "AUR installs must be run from a non-root user."
}

run_as_aur_user() {
  local user

  user=$(aur_user)
  if [[ "$(id -un)" == "$user" ]]; then
    "$@"
    return
  fi

  sudo -u "$user" "$@"
}

ensure_yay() {
  local build_dir

  if ! is_arch; then
    devenv_fail "AUR installs are only supported on Arch."
  fi

  if command -v yay >/dev/null 2>&1; then
    return
  fi

  install_packages base-devel git

  build_dir=$(mktemp -d /tmp/yay.XXXXXX)
  git clone https://aur.archlinux.org/yay.git "$build_dir"
  run_as_aur_user bash -lc "cd \"$build_dir\" && makepkg -si --noconfirm"
  rm -rf "$build_dir"
}

install_aur_packages() {
  if ! is_arch; then
    devenv_fail "AUR installs are only supported on Arch."
  fi

  ensure_yay
  run_as_aur_user yay -S --needed --noconfirm "$@"
}
