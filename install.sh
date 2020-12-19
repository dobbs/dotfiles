#!/bin/bash
set -euo pipefail

readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

main() {
  PATH=$PATH:$DIR/install.d
  install-brews
  install-font
  install-prelude
  install-zgen
  install-dotfiles
  install-url-handlers
  install-iterm2-configs
  install-emacs-packages
  install-local
}

install-brews() {
  BREWS='aspell
chezscheme
deno
duti
gnu-sed
gnu-tar
gnupg
go
graphviz
helm
httpie
jq
k3d
kind
kubebuilder
kubernetes-cli
kustomize
miller
node
openssl@1.1
stow
the_silver_searcher
tmux
tree
vault
wget'

  CASKS='1password
docker
firefox
google-chrome
iterm2
rectangle'

  comm -13 <(brew list --formula | sort) <(echo "$BREWS" | sort) | xargs brew install
  comm -13 <(brew list --cask | sort) <(echo "$CASKS" | sort) | xargs brew install --cask
  brew list --cask | grep -q emacs || brew install --cask emacs --no-quarantine
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

install-zgen() {
  local ZGEN="${HOME}/.zgen"
  test -d $ZGEN && (cd $ZGEN; git rev-parse --git-dir > /dev/null 2>&1) || {
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
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

parse-presets-to-json() {
  plutil -convert json -o - \
    -- ${HOME}/workspace/solarized/iterm2-colors-solarized/Solarized\ Light.itermcolors \
    | jq '{"Solarized Light" : .}'
}

iterm2-has-presets() {
  defaults read ~/Library/Preferences/com.googlecode.iterm2.plist "Custom Color Presets" > /dev/null 2>&1
}

install-iterm2-configs() {
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
    plutil -replace "New Bookmarks"."Scrollback Lines" \
           -integer 0 \
           -- ~/Library/Preferences/com.googlecode.iterm2.plist
    plutil -replace "New Bookmarks"."Option Key Sends" \
           -integer 2 \
           -- ~/Library/Preferences/com.googlecode.iterm2.plist
}

elisp-install-packages() {
  cat <<ELISP
(progn
 (message "\n\n####################")
 (package-initialize)
 (package-refresh-contents)
 (package-install-selected-packages)
)
ELISP
}

install-emacs-packages() {
  # hack chicken-and-egg problem: solarized theme isn't installed yet
  perl -pi -e 's{^.*solarized.*$}{}' home/.emacs.d/personal/preload/theme.el
  /Applications/Emacs.app/Contents/MacOS/Emacs \
    --batch -l ~/.emacs.d/init.el \
    --eval "$(elisp-install-packages)"
  git checkout -- home/.emacs.d/personal/preload/theme.el
}

install-local() {
  if [ -n "$(/bin/ls $DIR/install.d)" ]; then
    for installfile in $DIR/install.d/*
    do
      if [ -r "${installfile}" ]; then
        source "${installfile}"
      fi
    done
  fi
}

usage() {
  cat <<EOF
Usage: $(basename $0) COMMAND
  COMMANDs:
    all   installs everything below in the order listed
    brews
    font
    prelude
    zgen
    dotfiles
    url-handlers
    iterm2-configs
    emacs-packages
    local

EOF
}

readonly CMD=${1:-nothing}
case $CMD in
  all)
    main
    ;;
  brews|font|prelude|zgen|dotfiles|url-handlers|iterm2-configs|emacs-packages|local)
    install-$CMD
    ;;
  parse-presets-to-json|reformat-for-new-bookmarks)
    $CMD
    ;;
  *)
    usage
    ;;
esac
