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

Sometimes this trick doesn't work. In which case install the CLI tools
manually: https://developer.apple.com/download/more/?=xcode

### install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    compaudit | xargs chmod go-w  # to make zsh happier about file permissions

### prep directories
    mkdir -p .ssh workspace/dobbs

### get dotfiles source
    git clone https://github.com/dobbs/dotfiles.git workspace/dobbs/dotfiles

    cd ~/workspace/dobbs/dotfiles
    git remote set-url origin git@github.com:dobbs/dotfiles.git

### need openssl & docker for bootstrapping
    ./install.sh brews
    ./install.sh casks

### generate ssh key for github
    home/bin/d-keygen github.com
    open https://github.com/settings/ssh/new
    pbcopy < ~/.ssh/github.com/id_ecdsa.pub
    # title: mbp:~/.ssh/github.com/id_ecdsa.pub
    # key: paste from clipboard
    # click Add SSH key

### open iTerm2 & launch Docker

The install.sh script modifies the iTerm2 config file, but you have to
open the app first to create the default configuration.

Also startup the docker deamon so we can install kubernetes in docker
(via k3d).

last, but not least

   ./install.sh all
