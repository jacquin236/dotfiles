#!/usr/bin/env zsh

###### PYTHON RELATED ALIASES AND FUNCTIONS #####

## Python
builtin which py >/dev/null || alias py='python3'

alias pyfind='find . -name "*.py"'
alias pygrep='grep -nr --include="*.py"'
alias pyserver='python3 -m http.server'

# Run proper IPython regarding current virtualenv (if any)
alias ipython='python3 -c "import sys; del sys.path[0]; import IPython; sys.exit(IPython.start_ipython())"'

# Remove python compiled byte-code and mypy/pytest cache in either the current
# directory or in a list of specified directories (including sub directories).
function pyclean() {
  find "${@:-.}" -type f -name "*.py[co]" -delete
  find "${@:-.}" -type d -name "__pycache__" -delete
  find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
  find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

## Venv
function act() {
  [ -f 'bin/activate' ] && source bin/active
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
  [ -f 'environment.yml' ] && conda activate $(cat environment.yml | grep name: | head -n 1 | cut -f 2 -d ':')
  [ -f 'environment.yaml' ] && conda activate $(cat environment.yaml | grep name: | head -n 1 | cut -f 2 -d ':')
  return 0
}

## Pyenv
alias pythons='pyenv versions'
alias pyvirts='pyenv virtualenvs'

alias pydeact='pyenv deactivate'
alias pydoctor='pyenv doctor'
alias pyinstall='pyenv install'
alias pyshell='pyenv shell'
alias pyshims='pyenv shims'

function current python() {
  echo "$(pyenv version-name)"
}

## Poetry
alias poa='poetry add'
alias pob='poetry build'
alias poc='poetry check'
alias pocv='poetry config virtualenvs.create false'
alias poex='poetry export --without-hashes > requirements.txt'
alias poi='poetry init'
alias poin='poetry install'
alias poins='poetry install --sync'
alias por='poetry run'
alias porm='poetry remove'

alias posearch='poetry search'
alias poshell='poetry show'
alias poshow='poetry show --latest'

alias podi='poetry debug info'
alias podr='poetry debug resolve'

alias pocc='poetry cache clear'
alias pocl='poetry cache list'

alias poei='poetry env info'
alias poel='poetry env list'
alias poer='poetry env remove'
alias poeu='poetry env use'

alias posplug='poetry self show plugins'
alias posinst='poetry self install'

