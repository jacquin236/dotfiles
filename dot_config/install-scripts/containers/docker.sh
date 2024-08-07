#!/bin/sh

# shellcheck source-path=../..
. ../../helpers.sh

env_var
setup_color

setup_whalebrew() {
  if ! command -v "whalebrew" >/dev/null && command_exists brew; then
    fmtwarn "Updating/Installing whalebrew with Homebrew..."
    brew update >/dev/null
    if brew list whalebrew; then
      brew upgrade whalebrew
    else
      brew install whalebrew
    fi
  elif ! command -v "whalebrew" >/dev/null && ! type brew >/dev/null; then
    export WHALEBREW_CONFIG_DIR="$XDG_CONFIG_HOME/whalebrew"
    export WHALEBREW_INSTALL_PATH="$XDG_BIN_HOME/whalebrew"
    fmtwarn "Downloading whalebrew binary..."
    curl -L "https://github.com/whalebrew/whalebrew/releases/download/0.4.1/whalebrew-$(uname -s)-$(uname -m)" -o "$WHALEBREW_INSTALL_PATH"
    chmod +x "$WHALEBREW_INSTALL_PATH"

    # if checkyes "Export whalebrew environment to your bashrc/zshrc?"; then
    #   {
    #     echo 'export WHALEBREW_CONFIG_DIR="$XDG_CONFIG_HOME/whalebrew"'
    #     echo 'export WHALEBREW_INSTALL_PATH="$XDG_BIN_HOME/whalebrew"'
    #   } >>~/.bashrc
    #   {
    #     echo 'export WHALEBREW_CONFIG_DIR="$XDG_CONFIG_HOME/whalebrew"'
    #     echo 'export WHALEBREW_INSTALL_PATH="$XDG_BIN_HOME/whalebrew"'
    #   } >>"$ZDOTDIR/.zshrc"
    # fi
    if checkyes "Enable whalebrew completions?" && [ -n $ZSH_VERSION ]; then
      whalebrew completion zsh >|"$ZSH_CACHE_DIR/completions/_whalebrew"
    fi
    fmtsuccess "Installed whalebrew successfully!"
  fi
}

setup_lazydocker() {
  if ! command -v "lazydocker" >/dev/null && command_exists brew; then
    fmtwarn "Updating/Installing lazydocker with Homebrew..."
    brew update >/dev/null
    if brew list lazydocker; then
      brew upgrade lazydocker
    else
      brew install jesseduffield/lazydocker/lazydocker
    fi
  elif ! command -v "lazydocker" >/dev/null && ! type brew >/dev/null; then
    fmtwarn "Downloading lazydocker binary..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  fi
  fmtsuccess "Installed lazydocker successfully!"
}

main() {
  if command_exists docker; then
    if checkyes "Install/Update lazydocker?"; then
      setup_lazydocker
    fi
    if checkyes "Install/Update whalebrew?"; then
      setup_whalebrew
    fi
  fi
}

main
