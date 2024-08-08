### DO NOT POLLUTE YOUR HOME :)
# xdg
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/projects}

# zsh
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export ZSH_COMPDUMP=$XDG_CACHE_HOME/zsh/compdump/zcompdump$SHORT_HOST-$VERSION

# WSL Utilities
if [ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')" ] || command -v wslview >/dev/null; then
  export BROWSER=wslview
fi

if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -z-4'
fi

if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

if command -v nvim >/dev/null; then
  export SUDO_EDITOR=nvim
else
  export SUDO_EDITOR=vim
fi

# Manpages
if [ -d /usr/local/man ]; then
  export MANPATH="/usr/local/man:$MANPATH"
fi

# gnupg
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Get the colors in the opened man page itself
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"

# less
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/less_history"

# starship 
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Golang
export GOROOT="$XDG_BIN_HOME/go" || export GOROOT="$(brew --prefix go)"
export GOPATH="$XDG_DATA_HOME/go"

# nvm
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USER_CONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/nodejs/node_repl_history"

# rbenv (ruby)
export RBENV_ROOT="$XDG_DATA_HOME/rbenv" || export RBENV_ROOT="$(brew --prefix rbenv)"

# bundler, gems
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

# postgres
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"

# cargo, rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
fi

# pyenv, poetry, python
export PYENV_ROOT="$XDG_DATA_HOME/pyenv" || export PYENV_ROOT="$(brew --prefix pyenv)"
export POETRY_HOME="$XDG_DATA_HOME/pypoetry"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"

# jupiter
export JUPYTER_CONFIG_FIR="$XDG_CONFIG_DIR/jupyter"

# nvm, npm, node, pnpm
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USER_CONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/nodejs/node_repl_history"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export npm_config_cache="$XDG_CACHE_HOME/npm"

# whalebrew
export WHALEBREW_CONFIG_DIR="$XDG_CONFIG_HOME/whalebrew"
export WHALEBREW_INSTALL_PATH="$XDG_BIN_HOME/whalebrew"

# minikube
export MINIKUBE_HOME="$XDG_CONFIG_HOME/minikube"

# helm
export HELM_CACHE_HOME="$XDG_CACHE_HOME/helm"
export HELM_CONFIG_HOME="$XDG_CONFIG_HOME/helm"
export HELM_DATA_HOME="$XDG_DATA_HOME/helm"

# kubectl
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"

### Add programs bin to path ###
# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then add_to_path "$HOME/bin"; fi
if [ -d "$XDG_BIN_HOME" ]; then add_to_path "$XDG_BIN_HOME"; fi
if [ -d /usr/local/sbin ]; then add_to_path "/usr/local/sbin"; fi

# rbenv
if [ -d "$RBENV_ROOT/bin" ]; then add_to_path "$RBENV_ROOT/bin"; fi

# pyenv, poetry
if [ -d "$PYENV_ROOT/bin" ]; then add_to_path "$PYENV_ROOT/bin"; fi
if [ -d "$PYENV_ROOT/shims" ]; then add_to_path "$PYENV_ROOT/shims"; fi
if [ -d "$PYENV_ROOT/versions/3.12.0/bin" ]; then add_to_path "$PYENV_ROOT/versions/3.12.0/bin"; fi
if [ -d "$POETRY_HOME/bin" ]; then add_to_path "$POETRY_HOME/bin"; fi

# pnpm, nvm
if [ -d "$PNPM_HOME/bin" ]; then add_to_path "$PNPM_HOME/bin"; fi
if command -v npm >/dev/null; then add_to_path "$(npm config get prefix)/bin"; fi

# go
if [ -d "$GOROOT/bin" ]; then add_to_path "$GOROOT/bin"; fi
if [ -d "$GOROOT/bin" ]; then add_to_path "$GOPATH/bin"; fi
