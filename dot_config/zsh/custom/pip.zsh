#!/usr/bin/env zsh

##### PIP RELATED ALIASES AND FUNCTIONS #####
if (( ${+commands[pip3]} && ! ${+commands[pip]} )); then
  alias pip="noglob pip3"
else
  alias pip="noglob pip"
fi

alias pipin='pip install'
alias pipun='pip uninstall'

# requirements.txt
alias pipre="pip freeze > requirements.txt"
alias pipir="pip install -r requirements.txt"
alias pipli="pip freeze | grep -v 'pkg-resources' > requirements.txt; cat requirements.txt"

### Functions
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

### PIPENV ###
if (( ! ${+commands[pipenv]} )); then
  return
fi

eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

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
