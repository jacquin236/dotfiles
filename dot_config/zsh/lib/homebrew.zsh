# Completions
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

# Brew aliases
function brews() {
  local formulae="$(brew leaves | xargs brew deps --installed --for-each)"
  local casks="$(brew list --cask 2>/dev/null)"

  local blue="$(tput setaf 4)"
  local bold="$(tput bold)"
  local off="$(tput sgr0)"

  echo "${blue}==>${off} ${bold}Formulae${off}"
  echo "${formulae}" | sed "s/^\(.*\):\(.*\)$/\1${blue}\2${off}/"
  echo "\n${blue}==>${off} ${bold}Casks${off}\n${casks}"
}

alias brewa='brew autoremove'
alias brewc='brew cleanup'
alias brewi='brew install'
alias brewl='brew list'
alias brewo='brew outdated'
alias brewp='brew pin'
alias brews='brew search'
alias brewu='brew upgrade'
alias brewun='brew uninstall'
alias brewup="brew update && brew upgrade && brew cleanup"
alias brewinfo="brew leaves | xargs brew desc --eval-all"


# Aliases for Homebrew use fzf
if (( ! ${+commands[fzf]} )); then
  return
fi
  
# https://github.com/junegunn/fzf/wiki/Examples#homebrew
# Install (one or multiple) selected application(s)
# mnemonic [B]rew [I]nstall [P]ackage
bip() {
  inst=$(brew search "$@" | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst); do
      brew install $prog
    done
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]ackage
bup() {
  upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd); do
      brew upgrade $prog
    done
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]ackage (e.g. uninstall)
bcp() {
  uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst); do
      brew uninstall $prog
    done
  fi
}

### Update Homebrew ###
function update brew() {
  brew update && brew upgrade
}