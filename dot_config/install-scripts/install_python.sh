#!/bin/sh

# shellcheck source-path=..
. ../helpers.sh

GITHUB="https://github.com/"

setup_color
env_var

checkout() {
  [ -d "$2" ] || git -c advice.detachedHead=0 clone --branch "$3" --depth 1 "$1" "$2"
}

install_pyenv() {
  export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
  fmtwarn "Checking required dependencies first..."
  check_apt_packages build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev

  if command_exists brew && checkyes "Install pyenv with Homebrew?"; then
    fmtwarn "Trying to install/update pyenv with Homebrew..." &&
      check_brew_packages gcc openssl readline sqlite3 xz zlib tcl-tk llvm
    check_brew_packages pyenv
    eval "$(pyenv init -)"
    fmtsuccess "Done installing pyenv."
    if checkyes "Install pyenv plugins?"; then
      brew install pyenv-virtualenv
      eval "$(pyenv virtualenv-init -)"
    fi
  else
    if checkyes "Install pyenv with git?"; then
      fmtwarn "Trying to install/update pyenv with git..."

      if [ -d "$PYENV_ROOT" ]; then
        rm -rf "$PYENV_ROOT"
      fi

      checkout "${GITHUB}pyenv/pyenv.git" "${PYENV_ROOT}" "${PYENV_GIT_TAG:-master}"
      checkout "${GITHUB}pyenv/pyenv-doctor.git" "${PYENV_ROOT}/plugins/pyenv-doctor" "master"
      checkout "${GITHUB}pyenv/pyenv-update.git" "${PYENV_ROOT}/plugins/pyenv-update" "master"
      checkout "${GITHUB}pyenv/pyenv-virtualenv.git" "${PYENV_ROOT}/plugins/pyenv-virtualenv" "master"

      cd "$PYENV_ROOT" && src/configure && make -C src

      {
        "${PYENV_ROOT}/bin/pyenv" init || true
        "${PYENV_ROOT}/bin/pyenv" virtualenv-init || true
      } >&2

    fi
  fi
  fmtsuccess "Installed Pyenv!" || err_exit "Failed to install Pyenv."
}

install_version() {
  eval "$(pyenv init -)"
  pyenv install --list | grep '^ 3.'
  printf "Choose a Python version: " && read -r version
  pyenv install "$version" --verbose
  fmtsuccess "You install Python $version successfully. Please set a default version with 'pyenv global $version'" ||
    err_exit "Could not install Python $version".
}

install_poetry() {
  if ! command -v "poetry" >/dev/null && checkyes "You do not have Poetry install, install now?"; then
    fmtwarn "Installing Poetry..."
    export POETRY_HOME="$XDG_DATA_HOME/pypoetry"
    export PATH="$POETRY_HOME/bin:$PATH"
    curl -sSL https://install.python-poetry.org | python3 -
    echo "Check version " && poetry --version
    # if checkyes "Enable Tab Completion for your Shell?"; then
    #   fmtinfo "Add completion for bash..."
    #   poetry completions bash >"${XDG_DATA_HOME:-~/.local/share}"/bash-completion/completions/poetry
    #   fmtinfo "Add completion for zsh..."
    #   mkdir "$ZSH_CUSTOM"/plugins/poetry
    #   poetry completions zsh >"$ZSH_CUSTOM"/plugins/poetry/_poetry
    #   fmtwarn "Please add 'poetry' to your plugins array in '.zshrc'"
    # fi
    fmtsuccess "You have PyPoetry installed!" || err_exit "Installed Poetry failed."
  fi
}

main() {

  if ! command_exists pyenv; then
    if checkyes "Seems like you don't have pyenv installed. Install it now?"; then
      install_pyenv
      install_version
    fi
  elif ! command_exists poetry; then
    install_poetry
  else
    install_version
  fi
}

main
