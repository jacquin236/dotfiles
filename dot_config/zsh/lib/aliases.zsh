## Reload shell
function reload() {
  command rm -f $ZSH_COMPDUMP
  local zsh="${ZSH_ARGZERO:=${functrace[-1]%:*}}"
  [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}

## Config files (implement chezmoi)
alias zdot='chezmoi cd $ZDOTDIR'
alias zlib='chezmoi cd $ZDOTDIR/lib'
alias zcus='chezmoi cd $ZDOTDIR/custom'
alias zshrc='chezmoi edit $ZDOTDIR/.zshrc'
alias zshenv='chezmoi edit $ZDOTDIR/.zshenv'
alias zaliases='chezmoi edit $ZDOTDIR/lib/aliases.zsh'
alias zenv='chezmoi edit $ZDOTDIR/lib/env.zsh'
alias zplug='chezmoi edit $ZDOTDIR/zplugin.zsh'

alias bashrc='chezmoi edit ~/.bashrc'
alias bashprof='chezmoi edit ~/.profile'

alias nvimconf='chezmoi cd $XDG_CONFIG_HOME/nvim'
alias nvimrc='chezmoi edit $XDG_CONFIG_HOME/nvim/init.lua'

alias stars='chezmoi edit $XDG_CONFIG_HOME/starship/starship.toml'

# Bat global 'help' command
if (( ${+commands[bat]} )); then
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain --color=always --theme="TwoDark"'
fi

# Backup
function bak() {
  local filename
  setopt shwordsplit
  for filename in "$@"; do
    local bak_files="$filename.bak"
    if [ -f "$filename" ]; then
      mv -i "$filename" "$bak_file"
      [ -f "$filename" ] && tput setaf3; echo "Skipping $filename"; tput sgr0
    fi
  done
}

function unbak() {
  local filename
  setopt shwordsplit
  for filename in "$@"; do
    if [[ ! "$filename" =~ *.bak ]]; then
      continue    
    fi
    local bak_file="${filename:r}"
    if [ -f "$filename" ]; then
      mv -i "$filename" "$bak_file"
      [ -f "$filename" ] && tput setaf3; echo "Skipping $filename"; tput sgr0
    fi
  done
}

