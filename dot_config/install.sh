#!/bin/sh

# shellcheck source-path=SCRIPTDIR
. ./helpers.sh

setup_color
env_var

base_dir() {
  # Create backup dir
  fmtwarn "Creating backup dir..."
  backup_dir="$XDG_CACHE_HOME/backup"
  if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
  fi

  # Create temp dir
  fmtwarn "Creating temp dir..."
  [ -z "$MYTEMPDIR" ] && MYTEMPDIR="${TEMPDIR:-/tmp}/$USER"
  if [ ! -d "$MYTEMPDIR" ]; then mkdir -p "$MYTEMPDIR"; fi

  # Create gnupg dir
  fmtwarn "Creating gnupg dir..."
  if [ ! -d "$XDG_DATA_HOME/gnupg" ]; then
    (mkdir -p "$XDG_DATA_HOME/gnupg" && chmod 600 "$XDG_DATA_HOME/gnupg")
  fi

  fmtwarn "Creating wget dir..."
  if [ ! -d "$XDG_CONFIG_HOME/wget" ]; then
    mkdir -p "$XDG_CONFIG_HOME/wget" && touch "$XDG_CONFIG_HOME/wget/wgetrc"
    echo "hsts-file = \"$XDG_CACHE_HOME\"/wget/wget-hsts" >>"$XDG_CONFIG_HOME/wget/wgetrc"
    echo "logfile = /dev/null" >>"$XDG_CONFIG_HOME/wget/wgetrc"
    if [ -f "$HOME/.wget-hsts" ]; then
      mkdir -p "$XDG_CACHE_HOME/wget" && mv "$HOME/.wget-hsts" "$XDG_CACHE_HOME/wget/wget-hsts"
    fi
  fi
}

base_deps() {
  fmtinfo "Update machine and install prior dependencies..."
  check_apt_packages git ca-certificates build-essential gcc make cmake wamerican
  fmtsuccess "Done!"
}

is_wsl() {
  if [ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" ]; then
    echo "${COLOR_YELLOW}Your machine is running on WSL. It is highly recommended to install 'wslu'."
    echo "Please SKIP this step if you already installed."
    if checkyes "Install now?"; then
      fmtwarn "Downloading utilities for WSL (wslu)."
      sudo add-apt-repository ppa:wslutilities/wslu
      sudo apt update
      sudo apt install -y wslu
      fmtsuccess "Installed wslu."
    fi
  fi
}

setup_homebrew() {
  if ! type brew >/dev/null; then
    echo "${COLOR_YELLOW}Homebrew is highly recommended to install since it helps our setup process"
    echo "much much much more easier. If you DO NOT WANT to install Homebrew, please"
    echo "skip this step! Thank you.${FMT_RESET}"
    if checkyes "Install Homebrew?"; then
      check_apt_packages curl file git build-essential
      fmtwarn "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      fmtsuccess "Congrats! Installed Homebrew successfully!"
    fi
  fi
}

brew_packages_install() {
  if command_exists brew; then
    if checkyes "Found Homebrew. Would you like to install/upgrade recommended packages?"; then
      check_brew_packages fzf bat fd tree rg jq yq gh lazygit git-delta
      if ! command -v "chezmoi" >/dev/null && checkyes "Install chezmoi for dotfiles management?"; then
        check_brew_packages chezmoi
      fi
      if ! command -v "nvim" >/dev/null && checkyes "Install neovim?"; then
        check_brew_packages neovim luajit luarocks
      fi
    fi
    fmtsuccess "Installed Homebrew packages."
  fi
}

setup_zsh() {
  fmtinfo "Start setting up ZSH."
  # ZSH and Oh-My-Zsh setup
  if ! command -v "zsh" >/dev/null; then
    if checkyes "Could not find ZSH on your machine. Install zsh?"; then

      ZDOTDIR="$XDG_CONFIG_HOME/zsh"

      if [ ! -d "$ZDOTDIR" ]; then
        mkdir -p "$ZDOTDIR"
      fi

      check_apt_packages zsh
      if checkyes "Make zsh your default shell?"; then
        chsh -s "$(which zsh)" "$USER"
        fmtinfo "Set zsh as your default shell. Please reload your shell to take effect."
      fi
    fi
    fmtsuccess "Installed Zsh!"
  fi
}

setup_omz() {
  if command_exists zsh; then
    if ! command -v "omz" >/dev/null; then
      if checkyes "You have ZSH on the machine. Setup Oh-My-Zsh framework?"; then
        fmtwarn "Setting up Oh-My-Zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$XDG_DATA_HOME/zsh/ohmyzsh"
        export ZSH="$XDG_DATA_HOME/zsh/ohmyzsh"
        if checkyes "Would you like to put your 'custom' directory in your Config Dir?"; then
          # ZSH_CUSTOM="$XDG_DATA_HOME/zsh_custom"
          ZSH_CUSTOM="$ZDOTDIR/custom"
        else
          ZSH_CUSTOM="$ZSH/custom"
        fi
      fi
      echo
      if checkyes "Setup neccessary plugins for OMZ?"; then
        fmtwarn "Cloning 'fast-syntax-highlighting'..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
          "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
        fmtwarn "Cloning 'zsh-autosuggestions'..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git \
          "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        fmtwarn "Cloning 'zsh-autocomplete'..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git \
          "$ZSH_CUSTOM/plugins/zsh-autocomplete"
        fmtwarn "Cloning 'forgit'..."
        git clone https://github.com/wfxr/forgit.git \
          "$ZSH_CUSTOM/plugins/forgit"
        fmtwarn "Cloning 'evalcache'..."
        git clone https://github.com/mroth/evalcache \
          "$ZSH_CUSTOM/plugins/evalcache"
        fmtsuccess "Done installing OMZ plugins. Please add them in your config file."
      fi
    fi
    fmtsuccess "Installed OMZ successfully." || fmterror "Failed install omz"
  fi
}

main_setup() {
  base_dir
  base_deps
  is_wsl
  setup_homebrew
  brew_packages_install
  setup_zsh
  setup_omz
}

main_setup
