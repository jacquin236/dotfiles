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

# jupiter
export JUPYTER_CONFIG_FIR="$XDG_CONFIG_DIR/jupyter"

# nvm, npm, node, pnpm
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USER_CONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/nodejs/node_repl_history"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export npm_config_cache="$XDG_CACHE_HOME/npm"

if [ -d $NVM_DIR ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

# whalebrew
export WHALEBREW_CONFIG_DIR="$XDG_CONFIG_HOME/whalebrew"
export WHALEBREW_INSTALL_PATH="$XDG_BIN_HOME/whalebrew"

# minikube
export MINIKUBE_HOME="$XDG_CONFIG_HOME/minikube"

### fzf ###
# Make with: https://vitormv.github.io/fzf-themes/
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#a6adc8,fg+:#cdd6f4,bg:#181825,bg+:#181825
  --color=hl:#89b4fa,hl+:#89dceb,info:#cba6f7,marker:#a6e3a1
  --color=prompt:#f38ba8,spinner:#cba6f7,pointer:#fab387,header:#f9e2af
  --color=border:#89b4fa,scrollbar:#cba6f7,preview-scrollbar:#cba6f7,label:#f2cdcd
  --color=query:#bac2de
  --border="rounded" --border-label="" --preview-window="border-rounded" --padding="2"
  --margin="3" --prompt="➽ " --marker="❯ " --pointer="✦ "
  --separator="─" --scrollbar="❚" --layout="reverse" --info="right"'

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMANDS="$FZF_DEFAULT_COMMAND"


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
if [ -d "$NVM_DIR" ] && [ -r "$NVM_DIR"/bash_completion ]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi 
if [ -d "$PNPM_HOME/bin" ]; then add_to_path "$PNPM_HOME/bin"; fi
if command -v npm >/dev/null; then add_to_path "$(npm config get prefix)/bin"; fi

# go
if [ -d "$GOROOT/bin" ]; then add_to_path "$GOROOT/bin"; fi
if [ -d "$GOROOT/bin" ]; then add_to_path "$GOPATH/bin"; fi