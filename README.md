# bootstrapping

The point of this repo is to simplify bootstrapping a new computer.
Also helps keep multiple computers kinda in sync.  There's a definite
red-queen effect with every new device.  The Internet moves faster
than this repo can keep up.

I try to write the scripts to be sorta idempotent. It shouldn't hurt
to re-run them.

### install CLI tools
    xcode-select --install
    # click Install button

### install homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    compaudit | xargs chown go-w  # to make zsh happier about file permissions

### prep directories
    mkdir -p .ssh workspace/dobbs

### get dotfiles source
    git clone https://github.com/dobbs/dotfiles.git workspace/dobbs/dotfiles

    cd ~/workspace/dobbs/dotfiles
    git remote set-url origin git@github.com:dobbs/dotfiles.git

### need openssh & docker for bootstrapping
    ./install.sh brews

### generate ssh key for github
    home/bin/d-keygen github.com
    open https://github.com/settings/ssh/new
    pbcopy < ~/.ssh/github.com/id_ecdsa.pub
    # title: mbp:~/.ssh/github.com/id_ecdsa.pub
    # key: paste from clipboard
    # click Add SSH key
