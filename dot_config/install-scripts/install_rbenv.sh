#!/bin/sh

# shellcheck source-path=..
. ../helpers.sh

GITHUB="https://github.com/"

env_var
setup_color

checkout() {
  [ -d "$2" ] || git -c advice.detachedHead=0 clone --branch "$3" --depth 1 "$1" "$2"
}

brew_install() {
  if type brew >/dev/null; then
    if command_exists rbenv; then
      fmtwarn "You already installed rbenv"
      if checkyes "Reinstall?"; then
        brew reinstall rbenv
      else
        brew upgrade rbenv
      fi
    else
      check_brew_packages rbenv
    fi
    fmtinfo "Start install rbenv plugins..."
    check_brew_packages ruby-build rbenv-gemset
  fi
}

git_install() {
  export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
  check_apt_packages git
  if [ -d "$RBENV_ROOT" ]; then
    fmtwarn "Found rbenv dir in $RBENV_ROOT"
    rm -rf "$RBENV_ROOT"
  fi

  checkout "${GITHUB}rbenv/rbenv.git" "${RBENV_ROOT}" "master"
  checkout "${GITHUB}rbenv/ruby-build.git" "${RBENV_ROOT}/plugins/ruby-build" "master"
  checkout "${GITHUB}jf/rbenv-gemset.git" "${RBENV_ROOT}/plugins/rbenv-gemset" "master"

  cd "$RBENV_ROOT" && ./bin/rbenv init

  # Enable caching of rbenv-install downloads
  mkdir -p "$RBENV_ROOT/cache"
}

doctor() {
  if checkyes "Install 'rbenv-doctor'?"; then
    if hash wget 2>/dev/null; then
      wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor -O- | bash
    else
      curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
    fi
  fi
}

install_version() {
  rbenv install -l | grep '^ 3.'
  printf "Choose a Ruby version: " && read -r version
  rbenv install "$version" --verbose
  fmtsuccess "You install Ruby $version successfully. Please set a default version with 'rbenv global $version'" ||
    fmterror "Could not install Python $version".
}

main() {
  if type brew >/dev/null; then
    brew_install
    doctor
  else
    git_install
    doctor
  fi
  install_version
}
main
