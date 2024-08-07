#!/usr/bin/env zsh

## Ruby
alias rb='ruby'
alias rfind='find . -name "*.rb" | xargs grep -n'
alias rrun='ruby -e'

## Gem
alias gemb="gem build *.gemspec"
alias gemca='gem cert --add'
alias gemcr='gem cert --remove'
alias gemcb='gem cert --build'
alias gemch='gem check'
alias gemcl='gem cleanup -n'
alias gemi='gem info'
alias gemia='gem info --all'
alias geml='gem list'
alias gemlo='gem lock'
alias gemo='gem open -e'
alias gemod='gem outdated'
alias gemp="gem push *.gem"

alias gemin='gem install'
alias gemun='gem uninstall'

alias gemsu='sudo gem'

function update gem() {
  gem update
}

## RBENV
if (( ! ${+commands[rbenv]} )); then
  return
fi

alias rubies="rbenv versions"
alias rinst='rbenv install'
alias runst='rbenv uninstall'
alias rshell='rbenv shell'

alias gemsets="rbenv gemset list"

alias gemsa='rbenv gemset active'
alias gemsc='rbenv gemset create'
alias gemsd='rbenv gemset delete'
alias gemsf='rbenv gemset file'
alias gemsi='rbenv gemset init'

function current ruby() {
  echo "$(rbenv version-name)"
}

function current gemset() {
  echo "$(rbenv gemset active 2>/dev/null)" | tr ' ' '+'
}

function gems() {
  reset_color=$(printf '\033[0m')
  magenta=$(printf '\033[38;5;163m')
  yellow=$(printf '\033[33m')
  green=$(printf '\033[32m')
  blue=$(printf '\033[34m')
  
  local rbenv_path=$(rbenv prefix)
  gem list $@ | sed -E \
    -e "s/\([0-9a-z, \.]+( .+)?\)/$blue&$reset_color/g" \
    -e "s|$(echo $rbenv_path)|$magenta\$rbenv_path$reset_color|g" \
    -e "s/$current_ruby@global/$yellow&$reset_color/g" \
    -e "s/$current_ruby$current_gemset$/$green&$reset_color/g"
}