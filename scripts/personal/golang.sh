#!/usr/bin/env bash

get_latest_go_version() {
  local version

  version="$(curl -s https://go.dev/VERSION?m=text 2>/dev/null | head -1)"
  if [[ $version == go* ]]; then
    echo "${version#go}"
    return
  fi

  version=$(curl -s https://api.github.com/repos/golang/go/releases/latest 2>/dev/null | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
  if [[ $version == go* ]]; then
    echo "${version#go}"
    return
  fi

  echo "Could not determine latest Go version" >&2
  exit 1
}

get_arch() {
  local arch
  arch=$(uname -m)
  case $arch in
  x86_64) echo "amd64" ;;
  aarch64 | arm64) echo "arm64" ;;
  armv7l) echo "armv6l" ;;
  *) error "Unsupported architecture: $arch" ;;
  esac
}

get_os() {
  local os
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case $os in
  linux | darwin) echo "$os" ;;
  *) error "Unsupported OS: $os" ;;
  esac
}

GO_VERSION=$(get_latest_go_version)
ARCH=$(get_arch)
OS=$(get_os)
echo -e "\nInstalling Go version: $GO_VERSION on $OS $ARCH\n"

curl -L "https://go.dev/dl/go${GO_VERSION}.${OS}-${ARCH}.tar.gz" -o "go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
rm "go${GO_VERSION}.${OS}-${ARCH}.tar.gz"

echo -e "\ngo $GO_VERSION installed successfully"
