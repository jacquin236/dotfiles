#!/bin/sh

# shellcheck source-path=..
. ../helpers.sh

env_var
setup_color

if ! command -v "cargo" >/dev/null || ! command -v "rustup" >/dev/null; then
  if checkyes "You do not have 'cargo' or 'rust' installed. Install now?"; then
    fmtinfo "Start installing RUSTUP"

    check_apt_packages gcc build-essential

    [ -z "$CARGO_HOME" ] && CARGO_HOME="$XDG_DATA_HOME/cargo"
    [ -z "$RUSTUP_HOME" ] && RUSTUP_HOME="$XDG_BIN_HOME/rustup"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    fmtsuccess "RUSTUP installed successfully."

    if checkyes "Would you like to install nightly toolchain?"; then
      fmtwarn "Start installing nightly toolchain..."
      rustup toolchain install nightly
      rustup nightly rustc --version
      if checkyes "Make nightly toolchain default?"; then
        rustup default nightly
      fi
      rustup update
      fmtsuccess "All Done!"
    fi
  fi
fi

if command_exists cargo; then
  echo "${COLOR_PINK}Cargo B(inary)Install ${COLOR_YELLOW}might be helpful if you want to work with existing CI"
  echo "artifacts and infrastructure, and with minimal overhead for package maintainers."
  echo "Binstall aims to be a drop-in replacement for 'cargo install' in many cases,"
  echo "and supports similar options. If you do not want to install 'cargo-binstall',"
  echo "please skipp this step.${FMT_RESET}"
  if checkyes "Install Cargo Binstall?"; then
    export CARGO_HOME="$XDG_DATA_HOME/cargo"
    . "$CARGO_HOME/env"
    cargo install cargo-binstall || if hash wget 2>/dev/null; then
      wget -O- https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    fi

    cargo binstall --no-confirm cargo-update
    fmtsuccess "You have done setting Cargo and Rust successfully!"
  fi
fi
