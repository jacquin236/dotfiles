#!/bin/sh

# shellcheck source-path=..
. ../helpers.sh

env_var
setup_color

if ! command -v "go" >/dev/null && checkyes "Could not find GOLANG. Install?"; then
  fmtinfo "Start installing GO"
  [ -z "$GOROOT" ] && GOROOT="$XDG_BIN_HOME/go"
  [ -z "$GOPATH" ] && GOPATH="$XDG_DATA_HOME/go"

  VERSION="1.22.5"
  OS="$(uname -s)"
  ARCH="$(uname -m)"
  case $OS in
  "Linux")
    case $ARCH in
    "x86_64") ARCH=amd64 ;;
    "aarch64") ARCH=arm64 ;;
    "armv6" | "armv7l") ARCH=armv6l ;;
    "armv8") ARCH=arm64 ;;
    "i686") ARCH=386 ;;
    .*386.*) ARCH=386 ;;
    esac
    PLATFORM="linux-$ARCH"
    ;;
  "Darwin")
    case $ARCH in
    "x86_64") ARCH=amd64 ;;
    "arm64") ARCH=arm64 ;;
    esac
    PLATFORM="darwin-$ARCH"
    ;;
  esac
  if [ -d "$GOROOT" ]; then
    fmterror "GO install directory ($GOROOT) already exists."
    if checkyes "Remove it to install new GO?"; then
      rm -rf "$GOROOT"
      echo "You just removed ($GOROOT)".
    fi
  else
    mkdir -p "$GOROOT"
  fi
  # Clean go path
  if [ -d "$GOPATH" ]; then
    rm -rf "$GOPATH"
  fi
  # Create new go path
  mkdir -p "$GOPATH/{src,pkg,bin}"
  PACKAGE_NAME="go$VERSION.$PLATFORM.tar.gz"
  TEMP_DIR=$(mktemp -d)
  fmtinfo "Downloading $PACKAGE_NAME..."
  start_download() {
    if hash wget 2>/dev/null; then
      wget https://go.dev/dl/$PACKAGE_NAME -O "$TEMP_DIR/go.tar.gz"
    else
      curl -o "$TEMP_DIR/go.tar.gz" https://go.dev/dl/$PACKAGE_NAME
    fi
    tar -C "$GOROOT" --strip-components=1 -xzf "$TEMP_DIR/go.tar.gz"
    rm -rf "$TEMP_DIR/go.tar.gz"
  }
  start_download || err_exit "Install Go FAILED. Exit"

  fmtinfo "Go$VERSION installed in $GOROOT. Make sure relogin into your shell or open a new terminal window to start using."
fi
