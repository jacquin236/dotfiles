# Reload shell
function reload() {
  command rm -f $ZSH_COMPDUMP
  local zsh="${ZSH_ARGZERO:=${functrace[-1]%:*}}"
  [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}

# Only load these funcs if we have fzf installed
if command -v fzf >/dev/null; then
  # Toggling between data sources with CTRL-D adn CTRL-F (fzf)
  ffd() {
    find * |
      fzf --prompt 'All> ' \
        --header 'CTRL-D: Directories / CTRL-F: Files' \
        --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
        --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)' \
        --bind 'enter:become(vim {})'
  }

  # Man pages
  fman() {
    man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | \
      awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | \
      bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
  }

  # Browsing Kubernetes pods.
  kpods() {
    FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
      fzf --info=inline --layout=reverse --header-lines=1 \
      --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
      --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
      --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
      --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
      --bind 'ctrl-o:execute:${EDITOR:-nvim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
      --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
      --preview-window up:follow \
      --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
  }
fi

# If we have fzf and ripgrep
if command -v fzf >/dev/null && command -v rg >/dev/null; then
  frg() {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
      --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --prompt '1. ripgrep> ' \
      --delimiter : \
      --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(nvim {1} +{2})'
  }
fi

# Ruby/gem
if command -v rbenv >/dev/null; then
  alias rubies="rbenv versions"
  alias gemsets="rbenv gemset list"
  
  function current_ruby() {
    echo "$(rbenv version-name)"
  }

  function current_gemset() {
    echo "$(rbenv gemset active 2>/dev/null)" | tr ' ' '+'
  }

  function gems() {
    local rbenv_path=$(rbenv prefix)
    gem list $@ | sed -E \
      -e "s/\([0-9a-z, \.]+( .+)?\)/$fg[blue]&$reset_color/g" \
      -e "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
      -e "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
      -e "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
  }
fi 

## Config files
alias zdot='cd $ZDOTDIR'
alias zcus='cd $ZDOTDIR/custom'
alias zlib='cd $ZDOTDIR/lib'
alias zshrc='nvim $ZDOTDIR/.zshrc'
alias zshenv='nvim $ZDOTDIR/.zshenv'
# Neovim
alias nvdir='cd $XDG_CONFIG_HOME/nvim'
alias nvrc='nvim $XDG_CONFIG_HOME/nvim/init.lua'
# Vim
alias virc='vim $HOME/.vimrc'
alias vidir='cd $HOME/.vim'
