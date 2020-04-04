#
# Configures Node local installation, loads version managers, and defines
# variables and aliases.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Zeh Rizzatti <zehrizzatti@gmail.com>
#   Indrajit Raychaudhuri <irc@indrajit.com>
#

# Possible lookup locations for manually installed nodenv and nvm.
local_nodenv_paths=({$NODENV_ROOT,{$XDG_CONFIG_HOME/,$HOME/.}nodenv}/bin/nodenv(N))
local_nvm_paths=({$NVM_DIR,{$XDG_CONFIG_HOME/,$HOME/.}nvm}/nvm.sh(N))

# Load manually installed NVM into the shell session.
if [[ -s "${NVM_DIR:=$HOME/.nvm}/nvm.sh" ]]; then
  # source "${NVM_DIR}/nvm.sh"
  # Testing out lazy nvm/node
  lazynvm() {
    unset -f nvm node npm npx
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
    if [ -f "$NVM_DIR/bash_completion" ]; then
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    fi
  }

  nvm() {
    lazynvm
    nvm $@
  }

  node() {
    lazynvm
    node $@
  }

  npm() {
    lazynvm
    npm $@
  }

  npx() {
    lazynvm
    npx $@
  }
fi

# Load manually installed or package manager installed nodenv into the shell
# session.
if (( $#local_nodenv_paths || $+commands[nodenv] )); then

  # Ensure manually installed nodenv is added to path when present.
  [[ -s $local_nodenv_paths[1] ]] && path=($local_nodenv_paths[1]:h $path)

  eval "$(nodenv init - zsh)"

# Load manually installed nvm into the shell session.
elif (( $#local_nvm_paths )); then
  source "$local_nvm_paths[1]" --no-use

# Load package manager installed nvm into the shell session.
elif (( $+commands[brew] )) \
      && [[ -d "${nvm_path::="$(brew --prefix 2> /dev/null)"/opt/nvm}" ]]; then
  source "$nvm_path/nvm.sh" --no-use
fi

unset local_n{odenv,vm}_paths nvm_path

# Return if requirements are not found.
if (( ! $+commands[node] && ! $#functions[(i)n(odenv|vm)] )); then
  return 1
fi

#
# Variables
#

N_PREFIX="${XDG_CONFIG_HOME:-$HOME/.config}/n"  # The path to 'n' cache.

#
# Aliases
#

# npm
alias npmi='npm install'
alias npml='npm list'
alias npmo='npm outdated'
alias npmp='npm publish'
alias npmP='npm prune'
alias npmr='npm run'
alias npms='npm search'
alias npmt='npm test'
alias npmu='npm update'
alias npmx='npm uninstall'

alias npmci='npm ci'
alias npmcit='npm cit'
alias npmit='npm it'
