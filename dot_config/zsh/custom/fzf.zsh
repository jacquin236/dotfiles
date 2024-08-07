if (( ! ${+commands[fzf]} )); then return; fi 

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


## Toggle CTRL-D/CTRL-F for Directories/Files
function zfd() {
  find * |
    fzf --prompt 'All> ' \
      --header 'CTRL-D: Directories / CTRL-F: Files' \
      --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
      --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)' \
      --bind 'enter:become(vim {})'
}

# Man pages
function zman() {
  man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | \
    awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | \
    bat -l man -p --color=always' | tr -d '()' | \
    awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# Browsing Kubernetes pods.
function zpods() {
  FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    --header $'Γò▒ Enter (kubectl exec) Γò▒ CTRL-O (open log in editor) Γò▒ CTRL-R (reload) Γò▒\n\n' \
--bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
    --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-nvim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
    --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}

## Use CTRL-F (fzf) / CTRL-R (ripgrep)
zfrg() {
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
    --header 'Γò▒ CTRL-R (ripgrep mode) Γò▒ CTRL-F (fzf mode) Γò▒' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
}


