# install CLI tools
xcode-select --install
# click Install button

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mkdir -p .ssh workspace/dobbs

git clone https://github.com/dobbs/dotfiles.git workspace/dobbs/dotfiles
cd ~/workspace/dobbs/dotfiles
./install.sh brews # need openssh & docker

home/bin/d-keygen github.com
open https://github.com/settings/ssh/new
pbcopy < ~/.ssh/github.com/id_ecdsa.pub
# title: mbp:~/.ssh/github.com/id_ecdsa.pub
# key: paste from clipboard
# click Add SSH key
