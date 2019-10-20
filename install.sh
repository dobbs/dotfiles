#!/bin/bash
set -euo pipefail

main() {
  install-brews
  install-font
  install-prelude
  # TODO emacs install packages
  install-zgen
  install-shell
  install-dotfiles
  install-url-handlers
  install-solarized
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
  brew cask ls emacs > /dev/null 2>&1 || brew cask install emacs
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

install-prelude() {
  test -d "${HOME}/.emacs.d" || {
    curl -L https://github.com/bbatsov/prelude/raw/master/utils/installer.sh | sh
    rm -rf "${HOME}/.emacs.d/personal"
  }
}

parse-presets-to-json() {
  plutil -convert json -o - \
    -- ${HOME}/workspace/solarized/iterm2-colors-solarized/Solarized\ Light.itermcolors \
    | jq '{"Solarized Light" : .}'
}

iterm2-has-presets() {
  defaults read ~/Library/Preferences/com.googlecode.iterm2.plist "Custom Color Presets" > /dev/null 2>&1
}

install-solarized() {
    mkdir -p "${HOME}/workspace"
    test -d "${HOME}/workspace/solarized" || {
        (cd "${HOME}/workspace"; git clone git://github.com/altercation/solarized.git)
    }
    local PRESETS=$(parse-presets-to-json)
    if iterm2-has-presets; then
      plutil -replace "Custom Color Presets" -json "$PRESETS" \
           -- ~/Library/Preferences/com.googlecode.iterm2.plist
    else
      plutil -insert "Custom Color Presets" -json "$PRESETS" \
           -- ~/Library/Preferences/com.googlecode.iterm2.plist
    fi

    plutil -replace "New Bookmarks"."Normal Font" \
           -string "Hack-Regular 12" \
           -- ~/Library/Preferences/com.googlecode.iterm2.plist
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

install-url-handlers() {
  local lsregister="$(find /System/Library/Frameworks -name lsregister)"
  test -d /Applications/Xcode.app && $lsregister -u /Applications/Xcode.app
  test -d /Applications/Emacs.app && $lsregister /Applications/Emacs.app
  cat <<EOF | while read -r SCHEME; do duti -s org.gnu.emacs $SCHEME all; done
    public.source-code
    public.xml
    public.plain-text
EOF
}

usage() {
  cat <<EOF
Usage: $(basename $0) COMMAND
  COMMANDs:
    all
    brews
    font
    prelude
    solarized
    zgen
    shell
    dotfiles
    url-handlers

EOF
}

readonly CMD=${1:-nothing}
case $CMD in
  all)
    main
    ;;
  brews|font|prelude|solarized|zgen|shell|dotfiles|url-handlers)
    install-$CMD
    ;;
  parse-presets-to-json|reformat-for-new-bookmarks)
    $CMD
    ;;
  *)
    usage
    ;;
esac
