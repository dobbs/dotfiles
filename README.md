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

### update emacs packages

I do this rarely, and it's painful when I do. I do not have the
patience do develop fluency in emacs packages. Here are some notes
from the most recent episode of yak shaving stupid package conflicts.

    rm -rf ~/.emacs.d       # nuke the existing configuration
    ./install.sh prelude    # reinstall prelude defaults
    ./install.sh dotfiles   # fixes the symlink at ~/.emacs.d/personal

edit 'package-selected-packages in ./home/.emacs.d/personal/custom.el
oh-my-zsh emacs plugin launches emacs in deamon mode. So we have to
quit emacs from the MacOS application menu to close that deamon.

    ./install.sh emacs-packages
    e .

spot check editing:

double-check magit by testing a commit of the changes. This is one of
the main things that has broken in past upgrades.

double-check a javascript file to be sure indent configurations are
correctly set to two spaces (default is 4)

#### shell script to inspect changes to package-selected-packages

Review the diff of changes made to 'package-selected-packages. Copy
the old list into OLDER and the new list into NEWER. Then run this
command to get a readable report of the differences.

    OLDER="..."
    NEWER="..."

    echo -e "\nThings only in OLDER & not in NEWER"
    comm -23 <(tr ' ' "\n" <<<$OLDER | sort) <(tr ' ' "\n" <<<$NEWER | sort)

    echo -e "\nThings only in NEWER & not in OLDER"
    comm -13 <(tr ' ' "\n" <<<$OLDER | sort) <(tr ' ' "\n" <<<$NEWER | sort)

### maybe emacs updates would be easier if I did this more often

When I update rarely, some of these steps fail on conflicting packages
changes. Maybe if I think do this more frequently, the conflicts will
be simpler to resolve.

Inside emacs:

    M-x package-list-packages    # view all the packages
    / u                          # filter to view upgradable ones
    U                            # mark them to upgrade
    x                            # do the actual upgrades
    M-x prelude-update-packages  # update prelude packages
    M-x prelude-update           # update prelude itself
