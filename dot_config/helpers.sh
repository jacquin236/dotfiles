#!/bin/sh

if [ -t 1 ]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

setup_color() {
  # Only use colors if connected to a terminal
  if ! is_tty; then
    COLOR_RED=""
    COLOR_YELLOW=""
    COLOR_GREEN=""
    COLOR_BLUE=""
    COLOR_PURPLE=""
    COLOR_PINK=""
    FMT_BOLD=""
    FMT_RESET=""
    return
  fi

  COLOR_RED=$(printf '\033[38;5;196m')
  COLOR_YELLOW=$(printf '\033[33m')
  COLOR_GREEN=$(printf '\033[32m')
  COLOR_BLUE=$(printf '\033[34m')
  COLOR_PURPLE=$(printf '\033[38;5;093m')
  COLOR_PINK=$(printf '\033[38;5;163m')
  FMT_BOLD=$(printf '\033[1m')
  FMT_RESET=$(printf '\033[0m')

}

env_var() {
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_STATE_HOME="$HOME/.local/state"
  export XDG_BIN_HOME="$HOME/.local/bin"
  export XDG_PROJECTS_DIR="$HOME/projects"
  export XDG_RUNTIME_DIR="$HOME/.xdg"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  mkdir -p "$XDG_CONFIG_HOME"
  mkdir -p "$XDG_CACHE_HOME"
  mkdir -p "$XDG_DATA_HOME"
  mkdir -p "$XDG_STATE_HOME"
  mkdir -p "$XDG_BIN_HOME"
  mkdir -p "$XDG_PROJECTS_DIR"
  mkdir -p "$XDG_RUNTIME_DIR"
}

fmterror() {
  printf '%s\n' "${FMT_BOLD}${COLOR_RED}" "$*" "$FMT_RESET" >&2
}

fmtwarn() {
  printf '%s\n' "${FMT_BOLD}${COLOR_YELLOW}" "💁 $*" "$FMT_RESET" >&2
}

fmtsuccess() {
  printf '%s\n' "${FMT_BOLD}${COLOR_GREEN}" "🎉 $*" "$FMT_RESET" >&2
}

fmtinfo() {
  printf '%s\n' "${FMT_BOLD}${COLOR_BLUE}" "✨ $*" "$FMT_RESET" >&2
}

err_exit() {
  fmterror "$@"
  exit 1
}

command_exists() {
  command -v "$@" >/dev/null
}

checkyes() {
  printf "%s%s %s[Y/n]: " "${COLOR_PURPLE}" "$*" "$FMT_RESET" >&2
  read -r opt
  case $opt in
  y* | Y* | "") return 0 ;;
  n* | N*)
    echo "Skipped change."
    return 1
    ;;
  *)
    echo "Skipped change."
    return 1
    ;;
  esac
}

check_apt_packages() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    if [ "$(sudo find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
      echo "${COLOR_PINK}Running Update for package...${FMT_RESET}"
      sudo apt update -y
    fi
    echo "${COLOR_PINK}Installing missing package...${FMT_RESET}"
    sudo apt -y install --fix-missing "$@"
  fi
}

check_brew_packages() {
  brew update >/dev/null
  if brew ls --versions "$@" >/dev/null; then
    brew upgrade "$@"
  else
    brew install "$@"
  fi
}

true
