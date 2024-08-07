#!/bin/sh

# A Ruby & Gem version management...

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
      check_brew_packages libyaml rbenv
    fi
    fmtinfo "Start install rbenv plugins..."
    check_brew_packages ruby-build rbenv-gemset
  fi
}

git_install() {
  export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
  check_apt_packages git curl libssl-dev libreadline-dev zlib1g-dev autoconf \
    bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
  if [ -d "$RBENV_ROOT" ]; then
    fmtwarn "Found rbenv dir in $RBENV_ROOT"
    rm -rf "$RBENV_ROOT"
  fi

  checkout "${GITHUB}rbenv/rbenv.git" "${RBENV_ROOT}" "master"
  checkout "${GITHUB}rbenv/ruby-build.git" "${RBENV_ROOT}/plugins/ruby-build" "master"
  checkout "${GITHUB}jf/rbenv-gemset.git" "${RBENV_ROOT}/plugins/rbenv-gemset" "master"
  checkout "${GITHUB}rkh/rbenv-update.git" "${RBENV_ROOT}/plugins/rbenv-update" "master"
  checkout "${GITHUB}rkh/rbenv-whatis.git" "${RBENV_ROOT}/plugins/rbenv-whatis" "master"
  checkout "${GITHUB}rkh/rbenv-use.git" "${RBENV_ROOT}/plugins/rbenv-use" "master"
  checkout "${GITHUB}yyuu/rbenv-ccache.git" "${RBENV_ROOT}/plugins/rbenv-ccache" "master"

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
  eval "$(rbenv init - --no-rehash zsh)"
  rbenv install -l | grep '^ 3.'
  printf "Choose a Ruby version: " && read -r version
  rbenv install "$version" --verbose
  fmtsuccess "You install Ruby $version successfully. Please set a default version with 'rbenv global $version'" ||
    fmterror "Could not install Python $version".
}

main() {
  fmtinfo "Please choose your installation type: Homebrew/Git"
  if checkyes "Install/Update rbenv with Homebrew?"; then
    brew_install
    doctor
  elif checkyes "Install/Update rbenv using Git?"; then
    git_install
    doctor
  else
    if command_exists rbenv; then
      install_version
    else
      err_exit "Cannot find rbenv. Please install!"
    fi
  fi
}
main
