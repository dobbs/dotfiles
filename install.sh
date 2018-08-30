#!/bin/bash
set -euo pipefail

main() {
  install-brews
  # TODO install prelude
  # TODO emacs install packages
  install-font
  install-zgen
  set-shell-to-zsh
  install-dotfiles
}

install-brews() {
  BREWS='aspell
chezscheme
curl
emacs
gnu-tar
gnupg
graphviz
jq
miller
node
nvm
openssl
stow
the_silver_searcher
tmux
tree
zsh'

  comm <(brew ls) <(echo "$BREWS") | xargs brew install
}

install-font() {
  curl -sSL -o /tmp/hack.zip \
      https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
  unzip -j -d /Library/Fonts/ /tmp/hack.zip
}

install-zgen() {
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
}

set-shell-to-zsh() {
  echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/zsh
}

install-dotfiles() {
  stow --target=$HOME home
}
