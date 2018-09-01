#!/bin/bash
set -euo pipefail

main() {
  install-brews
  # TODO install prelude
  # TODO emacs install packages
  install-font
  install-zgen
  install-shell
  install-dotfiles
}

install-brews() {
  BREWS='aspell
chezscheme
duti
gnupg
graphviz
jq
miller
node
openssl
stow
the_silver_searcher
tmux
tree
zsh'

  comm -13 <(brew ls) <(echo "$BREWS") | xargs brew install
}

install-font() {
  local SOURCE=https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
  local TARGET_DIR=/Library/Fonts
  local ARCHIVE=/tmp/hack.zip
  ls $TARGET_DIR | grep -iq Hack || {
    test -f $ARCHIVE || curl -sSL -o $ARCHIVE $SOURCE
    unzip -j -d $TARGET_DIR $ARCHIVE
  }
}

install-zgen() {
  local ZGEN="${HOME}/.zgen"
  test -d $ZGEN && (cd $ZGEN; git rev-parse --git-dir > /dev/null 2>&1) || {
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
  }
}

install-shell() {
  local ZSH_PATH=/usr/local/bin/zsh
  fgrep -q $ZSH_PATH /etc/shells || {
    echo $ZSH_PATH | sudo tee -a /etc/shells
  }
  [ "$SHELL" == "$ZSH_PATH" ] || {
    chsh -s $ZSH_PATH
  }
}

install-dotfiles() {
  stow --target=$HOME home
}

usage() {
  cat <<EOF
Usage: $(basename $0) COMMAND
  COMMANDs:
    all
    brews
    font
    zgen
    shell
    dotfiles

EOF
}

readonly CMD=${1:-nothing}
case $CMD in
  all)
    main
    ;;
  brews|font|zgen|shell|dotfiles)
    install-$CMD
    ;;
  *)
    usage
    ;;
esac
