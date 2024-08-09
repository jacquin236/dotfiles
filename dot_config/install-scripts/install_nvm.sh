#!/bin/sh

# shellcheck source-path=..
. ../helpers.sh

env_var
setup_color

if ! command -v "nvm" >/dev/null || checkyes "Install Node Version Manager (nvm)?"; then
  nvm_install_dir() {
    if [ -n "$NVM_DIR" ]; then
      printf %s "${NVM_DIR}"
    else
      [ -z "${XDG_DATA_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm"
    fi
  }
  INSTALL_DIR="$(nvm_install_dir)"
  if [ -d "$INSTALL_DIR" ]; then
    fmterror "Found NVM directory already exist in $INSTALL_DIR"
    if checkyes "Are you sure that you want to remove this directory?"; then
      rm -rf "$INSTALL_DIR"
      echo "Removed NVM directory."
    fi
  fi
  start_download() {
    mkdir -p "$NVM_DIR"
    if hash wget 2>/dev/null; then
      NVM_DIR="$XDG_DATA_HOME/nvm" PROFILE=/dev/null bash -c 'wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash'
    else
      NVM_DIR="$XDG_DATA_HOME/nvm" PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash'
    fi
  }
  if start_download; then
    fmtsuccess "Install NVM successfully."
    if checkyes "Would you like to install node now?"; then
      # shellcheck disable=SC3046,SC1091
      source "$NVM_DIR/nvm.sh"
      if checkyes "Use --LTS (Y) or latest node (n)?"; then
        nvm install --lts
      else
        nvm install node
      fi
      checkyes "Install latest NPM version?" && nvm install-latest-npm
      fmtsuccess "All done!"
    fi
    if checkyes "Install PNPM?"; then
      export PNPM_HOME="$XDG_DATA_HOME/pnpm"
      # shellcheck disable=SC2155
      export PATH="$(npm config get prefix)/bin:$PNPM_HOME:$PATH"
      npm i -g pnpm
      pnpm i -g bun tree-sitter-cli '@11ty/eleventy'
      if checkyes "Install additional GIT tools?"; then
        npm i -g git-open
        npm i -g git-recent
      fi
    fi
    fmtsuccess "Installed nvm, node, npm, and pnpm. You are all set!"
  else
    fmterror "Failed installing NVM."
  fi
fi
