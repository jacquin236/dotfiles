if command -v starship >/dev/null; then
  _evalcache starship init zsh
fi

if command -v pyenv >/dev/null; then
  _evalcache pyenv init - --no-rehash zsh
  _evalcache pyenv virtualenv-init - zsh
fi

if command -v rbenv >/dev/null; then
  _evalcache rbenv init - --no-rehash zsh
fi

alias evalclear='_evalcache_clear'
