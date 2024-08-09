### ZINIT ###
typeset -gAH ZINIT

ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/bin
ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions
ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZPFX=$ZINIT[HOME_DIR]/polaris

if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -pv $ZINIT[HOME_DIR] && command chmod g-rwX $ZINIT[HOME_DIR]
  command git clone https://github.com/zdharma-continuum/zinit $ZINIT[BIN_DIR] && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source $ZINIT[BIN_DIR]/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### PLUGINS ###
# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-submods \
    zdharma-continuum/declare-zsh

# Oh-my-zsh lib / Plugins
zinit wait lucid light-mode for \
    OMZL::clipboard.zsh \
    OMZL::functions.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::key-bindings.zsh \
    OMZL::prompt_info_functions.zsh \
    OMZP::git \
    OMZP::svn-fast-info \
    OMZP::systemd \
    hlissner/zsh-autopair \
    wfxr/forgit \
  as"completion" \
    OMZP::gitfast/_git \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

export ZSH_EVALCACHE_DIR=$ZSH_CACHE_DIR/evalcache
zinit light mroth/evalcache
source "$ZDOTDIR/evalcache.zsh"

# Docker
if (( ${+commands[docker]} )); then
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_docker" ]]; then
    typeset -g -A _comps
    autoload -Uz _docker
    _comps[docker]=_docker
  fi
  zinit ice as"completion"
  zinit snippet OMZP::docker/completions/_docker
fi

# Kubectl
if (( ${+commands[kubectl]} )); then
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_kubectl" ]]; then
    typeset -g -A _comps
    autoload -Uz _kubectl
    _comps[kubectl]=_kubectl
  fi
  kubectl completion zsh 2> /dev/null >| "$ZINIT[COMPLETIONS_DIR]/_kubectl" &|
fi

# Minikube
if (( ${+commands[minikube]} )); then
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_minikube" ]]; then
    typeset -g -A _comps
    autoload -Uz _minikube
    _comps[minikube]=_minikube
  fi
  minikube completion zsh >| "$ZINIT[COMPLETIONS_DIR]/_minikube" &|
fi

# Rust
if (( ${+commands[rustup]} && ${+commands[cargo]} )); then
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_cargo" ]]; then
    autoload -Uz _cargo
    typeset -g -A _comps
    _comps[cargo]=_cargo
  fi
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_rustup" ]]; then
    autoload -Uz _rustup
    typeset -g -A _comps
    _comps[rustup]=_rustup
  fi

  rustup completions zsh >| "$ZINIT[COMPLETIONS_DIR]/_rustup" &|
  cat >| "$ZINIT[COMPLETIONS_DIR]/_cargo" <<'EOF'
#compdef cargo
source "$(rustc +${${(z)$(rustup default)}[1]} --print sysroot)"/share/zsh/site-functions/_cargo
EOF

  zinit ice as"completion"
  zinit snippet OMZP::rust/_rustc
fi

# Rbenv
if (( ${+commands[rbenv]} )); then
  zinit ice as"completion"
  zinit snippet https://raw.githubusercontent.com/rbenv/rbenv/master/completions/_rbenv 
fi
if (( ${+commands[rails]} )); then
  zinit ice as"completion"
  zinit snippet OMZP::rails/_rails
fi
if (( ${+commands[gem]} )); then
  zinit ice as"completion"
  zinit snippet OMZP::gem/completions/_gem
fi
if (( ${+commands[rake]} )); then
  zinit snippet OMZP::rake-fast
fi

# Golang
if (( ${+commands[go]} )); then
  zinit ice as"completion"
  zinit snippet OMZP::golang/_golang

  compctl -g "*.go" gofmt # standard go tools
  compctl -g "*.go" gccgo # gccgo

  # gc
  for p in 5 6 8; do
    compctl -g "*.${p}" ${p}l
    compctl -g "*.go" ${p}g
  done
  unset p
fi

# Pip
if (( ${+commands[pip]} )); then
  zinit ice as"completion"
  zinit snippet OMZP::pip/_pip
fi

if (( ${+commands[pipenv]} )); then
  if [[ ! -f "$ZINIT[COMPLETIONS_DIR]/_pipenv" ]]; then
    typeset -g -A _comps
    autoload -Uz _pipenv
    _comps[pipenv]=_pipenv
  fi

  _PIPENV_COMPLETE=zsh_source pipenv >| "$ZINIT[COMPLETIONS_DIR]/_pipenv" &|
fi

# Nvm. npm
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'nvim')
export NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

if (( ${+commands[npm]} )); then
  zinit light lukechilds/zsh-better-npm-completion
fi
if (( ${+commands[yarn]} )); then
  zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
  zinit light g-plane/zsh-yarn-autocompletions
fi
if (( ${+commands[pnpm]} )); then
  zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
  zinit light g-plane/pnpm-shell-completion
fi

zinit cdreplay -q