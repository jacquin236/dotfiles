#!/usr/bin/env zsh

##### PIP RELATED ALIASES AND FUNCTIONS #####
if (( ${+commands[pip3]} && ! ${+commands[pip]} )); then
  alias pip="noglob pip3"
else
  alias pip="noglob pip"
fi

alias pipi='pip install'
alias pipu='pip uninstall'

# requirements.txt
alias pipre='pip freeze > requirements.txt'
alias pipir='pip install -r requirements.txt'
alias pipli="pip freeze | grep -v 'pkg-resources' > requirements.txt; cat requirements.txt"

### Functions
# Cache for list of packages
ZSH_PIP_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache/pip}/zsh-cache"
ZSH_PIP_INDEXES=(https://pypi.org/simple/)
piplist=($(cat $ZSH_PIP_CACHE_FILE))

function pipcache packages() {
  if [[ ! -d ${ZSH_PIP_CACHE_FILE:h} ]]; then
      mkdir -p ${ZSH_PIP_CACHE_FILE:h}
  fi
  if [[ ! -f $ZSH_PIP_CACHE_FILE ]]; then
      echo -n "(...caching package index...)"
      tmp_cache=/tmp/zsh_tmp_cache
      touch $tmp_cache
      for index in $ZSH_PIP_INDEXES ; do
          # well... I've already got two problems
          curl -L $index 2>/dev/null | \
              sed -n '/<a href/ s/.*>\([^<]\{1,\}\).*/\1/p' \
               >> $tmp_cache
      done
      sort $tmp_cache | uniq | tr '\n' ' ' > $ZSH_PIP_CACHE_FILE
      rm $tmp_cache
  fi
}

function pipcache clear() {
  rm -f $ZSH_PIP_CACHE_FILE
  unset piplist
}

# Upgrade all installed packages
function pipupall {
  # non-GNU xargs does not support nor need `--no-run-if-empty`
  local xargs="xargs --no-run-if-empty"
  xargs --version 2>/dev/null | grep -q GNU || xargs="xargs"
  pip list --outdated | awk 'NR > 2 { print $1 }' | ${=xargs} pip install --upgrade
}

# Uninstall all installed packages
function pipunall {
  # non-GNU xargs does not support nor need `--no-run-if-empty`
  local xargs="xargs --no-run-if-empty"
  xargs --version 2>/dev/null | grep -q GNU || xargs="xargs"
  pip list --format freeze | cut -d= -f1 | ${=xargs} pip uninstall
}

### Update pip ###
function update pip() {
  pip install --upgrade pip
}


### PIPENV ###
if (( ! ${+commands[pipenv]} )); then
  return
fi

# Pipenv settings
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_NO_INHERIT=1
export PIPENV_IGNORE_VIRTUALENVS=1

# Pipenv aliases
alias pcheck='pipenv check'
alias pclean='pipenv clean'
alias pgraph='pipenv graph'
alias pinst='pipenv install'
alias popen='pipenv open'
alias ppy='pipenv --py'
alias prun='pipenv run'
alias pshell='pipenv shell'
alias psync='pipenv sync'
alias punst='pipenv uninstall'
alias pupd='pipenv update'
alias pvenv='pipenv --venv'